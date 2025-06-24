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
        timestamp: timestamp,
        seen: false);
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
    await http.post(
      Uri.parse("https://chat-app-server-u8vj.onrender.com/send"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "token": user['fcm'],
        "title": user['username'],
        "body": message,
        "payload": {
          "uid": userData!['uid'],
          "username": userData!['username'],
          "color": userData!['color'],
          "fcm": userData!['fcm']
        }
      }),
    );
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
      e;
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

  Future<void> markAsSeen(String userId, String otherUserId) async {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomid = ids.join('_');
    final messagesSnapshot = await _firestore
        .collection('chat_rooms')
        .doc(chatRoomid)
        .collection('messages')
        .where('senderId', isEqualTo: otherUserId)
        .where('seen', isEqualTo: false)
        .get();

    WriteBatch batch = _firestore.batch();

    for (var doc in messagesSnapshot.docs) {
      batch.update(doc.reference, {'seen': true});
    }

    await batch.commit();
  }

  Stream<Map<String, dynamic>> getLastMessage(
      String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomid = ids.join('_');
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomid)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      } else {
        return {};
      }
    });
  }

  String timeSinceSent(Timestamp timestamp) {
    final DateTime messageTime = timestamp.toDate();
    final diff = DateTime.now().difference(messageTime);
    if (diff.inMinutes < 1) return ' \u00B7 just now';
    if (diff.inMinutes < 60) return ' \u00B7 ${diff.inMinutes}m';
    if (diff.inHours < 24) return ' \u00B7 ${diff.inHours}h';
    if (diff.inDays < 7) return ' \u00B7 ${diff.inDays}d';
    return ' \u00B7 ${(diff.inDays / 7).floor()}w';
  }
}
