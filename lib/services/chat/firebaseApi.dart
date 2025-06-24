import 'package:chat_app/services/auth/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
}

class Firebaseapi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    final settings = await _firebaseMessaging.getNotificationSettings();
    switch (settings.authorizationStatus) {
      case AuthorizationStatus.notDetermined:
        final result = await _firebaseMessaging.requestPermission();
        NotificationsAllowed =
            result.authorizationStatus == AuthorizationStatus.authorized;

        break;
      case AuthorizationStatus.authorized:
        NotificationsAllowed = true;
        break;
      case AuthorizationStatus.denied:
        NotificationsAllowed = false;
        break;

      default:
    }

    FcmToken = await _firebaseMessaging.getToken();
    _firebaseMessaging.onTokenRefresh.listen((String Token) async {
      FcmToken = Token;
      if (userData != null) {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        final doc =
            await FirebaseFirestore.instance.collection('Users').doc(uid).get();
        if (doc.exists) {
          userData = doc.data();
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .set({'fcm': FcmToken}, SetOptions(merge: true));
        }
      }
    });
  }
}
