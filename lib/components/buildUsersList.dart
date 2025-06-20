import 'package:chat_app/components/userTile.dart';
import 'package:chat_app/pages/chatPage.dart';
import 'package:chat_app/services/auth/data.dart';
import 'package:chat_app/services/chat/chatService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BuildUserslist extends StatefulWidget {
  final String? query;
  const BuildUserslist({super.key, this.query});

  @override
  State<BuildUserslist> createState() => _BuildUserslistState();
}

class _BuildUserslistState extends State<BuildUserslist> {
  final user = FirebaseAuth.instance.currentUser!;

  List<Widget> usersList = [];
  final Chatservice _chatservice = Chatservice();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _chatservice.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Icon(Icons.error_outline_outlined);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitPulse(
            color: Colors.white,
          );
        }
        if (widget.query == null) {
          if (currentRoute == 'Home') {
            usersList = snapshot.data!
                .where((userdata) =>
                    userdata['email'] != user.email &&
                    ((userData!['chat'] as List)
                        .any((uid) => uid == userdata['uid'])))
                .map<Widget>(
                  (userdata) => UserTile(
                    user: userdata,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          user: userdata,
                        ),
                      ),
                    ),
                  ),
                )
                .toList();
          } else {
            usersList = snapshot.data!
                .where((userdata) =>

                    (userData!['contacts'] as List)
                        .any((uid) => uid == userdata['uid']))
                .map<Widget>(
                  (userdata) => UserTile(
                    user: userdata,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          user: userdata,
                        ),
                      ),
                    ),
                  ),
                )
                .toList();
          }
        } else {
          usersList = snapshot.data!
              .where((userdata) =>
                  userdata['username'].toString().trim().toLowerCase() ==
                      widget.query.toString().trim().toLowerCase() &&
                  userdata['email'] != user.email)
              .map<Widget>((userdata) => UserTile(
                  user: userdata,
                  onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              user: userdata,
                            ),
                          ),
                        ),
                      }))
              .toList();
        }

        return usersList.isNotEmpty
            ? ListView(children: usersList)
            : Center(
                child: Icon(Icons.bubble_chart),
              );
      },
    );
  }
}
