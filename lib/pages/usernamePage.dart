import 'package:chat_app/components/inputField.dart';
import 'package:chat_app/services/auth/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsernamePage extends StatefulWidget {
  const UsernamePage({super.key});

  @override
  State<UsernamePage> createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  TextEditingController userNameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          InputField(
            controller: userNameController,
            hintText: 'Username',
            obsecure: false,
          )
        ],
      ),
    );
  }
  
  Future<String?> pickUserName(BuildContext context) async {
    TextEditingController usernameController = TextEditingController();
    bool confirm = false;

    return showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Enter Username'),
              content: TextField(
                onChanged: (value) async {
                  bool isAvailable = await isUsernameAvailable(value.trim());
                  setState(() {
                    confirm = (value.trim().isNotEmpty && isAvailable);
                  });
                },
                controller: usernameController,
                decoration: InputDecoration(hintText: 'Username'),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  onPressed: confirm
                      ? () {
                          Navigator.of(context).pop(usernameController.text);
                        }
                      : null,
                  child: Text('Finish'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  Future<void> saveUser(UserCredential user) async {
    String? username = await pickUserName(context);
    if (username == null) {
      FirebaseAuth.instance.currentUser!.delete();
      return;
    }

    _firestore.collection('Users').doc(user.user!.uid).set({
      'uid': user.user!.uid,
      'email': userCredential.
      'username': username,
      'color': getRandomColor(),
      'contacts': [],
      'chat': [],
    }).then((_) => setState(() {
          showLogin = true;
        }));

    print('------------------->   saved');
  }
  Future<bool> isUsernameAvailable(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('Users')
        .where('username', isEqualTo: username.trim())
        .limit(1)
        .get();

    return result.docs.isEmpty;
  }

}
