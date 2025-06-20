import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool showLogin = true;
bool passwordNotMatched = false;
bool forgotPassword = false;
bool resetEmailSent = false;
String errorCode = '';
Duration loadingTime = Duration(milliseconds: 1500);
File? avatarImage;
Map<String, dynamic>? userData;
late UserCredential userCredential;
String currentRoute = 'Home';
String getRandomColor() {
  final random = Random();
  int r = random.nextInt(256);
  int g = random.nextInt(256);
  int b = random.nextInt(256);
  return '#FF${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}'
      .toUpperCase();
}

Future<void> fetchUserData() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(uid).get();

  if (userDoc.exists) {
    userData = userDoc.data() as Map<String, dynamic>;
    print(userData);
  }
}


