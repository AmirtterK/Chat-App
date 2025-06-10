import 'package:chat_app/pages/homePage.dart';
import 'package:chat_app/pages/loginPage.dart';
import 'package:chat_app/pages/usernamePage.dart';
import 'package:chat_app/services/auth/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) =>
          snapshot.hasData ? ( showLogin? HomePage() : UsernamePage() ) : LoginPage(),
    );
  }
}
