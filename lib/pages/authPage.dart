import 'package:chat_app/pages/homePage.dart';
import 'package:chat_app/pages/loginPage.dart';
import 'package:chat_app/pages/usernamePage.dart';
import 'package:chat_app/services/auth/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});
  Future<bool> _userExists(String uid) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final doc = await firestore.collection('Users').doc(uid).get();
    if (doc.exists) {
      userData = doc.data()!;
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .set({'fcmToken': FcmToken}, SetOptions(merge: true));

      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LoginPage();

        final user = snapshot.data!;
        return FutureBuilder<bool>(
          future: _userExists(user.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(
                body: Center(
                  child: SpinKitPulse(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              );
            }

            final UserExists = snapshot.data!;
            return UserExists ? HomePage() : UsernamePage();
          },
        );
      },
    );
  }
}
