import 'package:chat_app/components/inputField.dart';
import 'package:chat_app/components/signInButton.dart';
import 'package:chat_app/services/auth/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class UsernamePage extends StatefulWidget {
  const UsernamePage({super.key});

  @override
  State<UsernamePage> createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  TextEditingController userNameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isAvailable = true;
  bool processingCredentials = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              SizedBox(height: 140),
              Icon(
                Icons.person,
                size: 60,
              ),
              SizedBox(height: 60),
              InputField(
                controller: userNameController,
                hintText: 'Username',
                obsecure: false,
                onChanged: isUsernameAvailable,
              ),
              SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: !isAvailable && userNameController.text.isNotEmpty
                    ? Text(
                        'that username already exists!',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      )
                    : Text(''),
              ),
              Spacer(),
              processingCredentials
                  ? Center(
                      child: SpinKitPulse(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    )
                  : Opacity(
                      opacity: isAvailable && userNameController.text.isNotEmpty
                          ? 1
                          : 0.3,
                      child: SignInButton(
                        onTap: isAvailable && userNameController.text.isNotEmpty
                            ? saveUser
                            : null,
                        showLogin: false,
                        reset: false,
                      ),
                    ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveUser() async {
    setState(() {
      processingCredentials = true;
    });
    await _firestore
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'email': FirebaseAuth.instance.currentUser!.email,
      'username': userNameController.text.trim(),
      'color': getRandomColor(),
      'contacts': [],
      'chat': [],
      'block': [],
      'fcm': FcmToken
    });
    final doc = await _firestore
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (doc.exists) {
      userData = doc.data()!;
    }
    if (mounted) {
      context.replaceNamed('Home');
    }

    print('------------------->   saved');
  }

  Future<void> isUsernameAvailable(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('Users')
        .where('username', isEqualTo: username.trim())
        .limit(1)
        .get();
    setState(() {
      isAvailable = result.docs.isEmpty && username.trim().isNotEmpty;
    });
  }
}
