import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String recieverId;
  final String message;
  final Timestamp timestamp;
  final bool seen;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.recieverId,
    required this.message,
    required this.timestamp,
    required this.seen,
  });
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'recieverId': recieverId,
      'message': message,
      'timestamp': timestamp,
      'seen': seen,
    };
  }
}
