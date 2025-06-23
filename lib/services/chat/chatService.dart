import 'dart:convert';

import 'package:chat_app/classes/message.dart';
import 'package:chat_app/services/auth/data.dart';
import 'package:chat_app/services/chat/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class Chatservice {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUsersStream({String? query}) {
    final userDocStream =
        _firestore.collection('Users').doc(userData!['uid']).snapshots();
    if (query != null) {
      return _firestore.collection('Users').snapshots().map((snapshot) =>
          snapshot.docs
              .map((doc) {
                final user = doc.data();
                return user;
              })
              .where((user) =>
                  user['uid'] != userData!['uid'] &&
                  query == user['username'].toString().toLowerCase() &&
                  !(user['block'] as List).contains(userData!['uid']))
              .toList());
    }
    String requiredUsers;
    if (currentRoute == 'Home') {
      requiredUsers = 'chat';
    } else if (currentRoute == 'Contacts') {
      requiredUsers = 'contacts';
    } else {
      requiredUsers = 'block';
    }
    return userDocStream.asyncMap((userSnapshot) async {
      userData = userSnapshot.data();
      final requiredList =
          List<String>.from(userSnapshot.data()?[requiredUsers] ?? []);

      if (requiredList.isEmpty) return [];

      final chunks = <List<String>>[];
      for (var i = 0; i < requiredList.length; i += 10) {
        chunks.add(requiredList.sublist(
            i, i + 10 > requiredList.length ? requiredList.length : i + 10));
      }

      final futures = chunks.map((chunk) {
        return _firestore
            .collection('Users')
            .where('uid', whereIn: chunk)
            .get();
      });

      final querySnapshots = await Future.wait(futures);

      final allDocs = querySnapshots.expand((snap) => snap.docs).toList();

      return allDocs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> sendMessage(Map<String, dynamic> user, String message) async {
    String currentUserId = _auth.currentUser!.uid;
    String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        recieverId: user['uid'],
        message: message,
        timestamp: timestamp);
    List<String> ids = [currentUserId, user['uid']];
    ids.sort();
    String chatRoomid = ids.join('_');
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomid)
        .collection('messages')
        .add(newMessage.toMap());
    await addChat(userData!['uid'], user['uid']);
    await addChat(user['uid'], userData!['uid']);
    final response = await http.post(
      Uri.parse("https://chat-app-server-u8vj.onrender.com/send"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "token": user['fcm'],
        "title": user['username'],
        "body": message,
        "payload": {
          "uid":userData!['uid'],
          "username":userData!['username'],
          "color":userData!['color'],
          "fcm":userData!['fcm']
        }
      }),
    );

    if (response.statusCode == 200) {
      print("✅ Notification sent!");
    } else {
      print("❌ Failed: ${response.body}");
    }
  }

  Future<void> deleteMessage(String recieverId, Timestamp timestamp) async {
    String currentUserId = _auth.currentUser!.uid;
    List<String> ids = [currentUserId, recieverId];
    ids.sort();
    String chatRoomid = ids.join('_');
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomid)
          .collection('messages')
          .where('timestamp', isEqualTo: timestamp)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting message: $e');
    }
  }

  Stream<QuerySnapshot> getMessage(String userId, otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomid = ids.join('_');
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomid)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
