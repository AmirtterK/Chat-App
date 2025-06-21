import 'package:chat_app/services/auth/data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
Future<void> handleBackgroundMessage(RemoteMessage message)async {
  print('---------------------------');
  print('title: ${message.notification?.title}');
  print('body: ${message.notification?.body}');
  print('payload: ${message.data}');
  print('---------------------------');
}
class Firebaseapi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
     FcmToken = await _firebaseMessaging.getToken(); 
    print('Token: $FcmToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
