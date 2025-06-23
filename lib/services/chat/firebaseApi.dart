import 'package:chat_app/services/auth/data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('🔔 Handling a background message: ${message.messageId}');
}

class Firebaseapi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    await _firebaseMessaging.requestPermission();
    FcmToken = await _firebaseMessaging.getToken();
    print('Token: $FcmToken');
  }
}
