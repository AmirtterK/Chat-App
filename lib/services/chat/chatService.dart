import 'package:chat_app/classes/message.dart';
import 'package:chat_app/services/chat/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chatservice {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore
        .collection('Users')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final user = doc.data();
              return user;
            }).toList());
  }

  Future<void> sendMessage(String recieverId, message) async {
    String currentUserId = _auth.currentUser!.uid;
    String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        recieverId: recieverId,
        message: message,
        timestamp: timestamp);
    List<String> ids = [currentUserId, recieverId];
    ids.sort();
    String chatRoomid = ids.join('_');
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomid)
        .collection('messages')
        .add(newMessage.toMap());
    await addChat(FirebaseAuth.instance.currentUser!.uid, recieverId);
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
