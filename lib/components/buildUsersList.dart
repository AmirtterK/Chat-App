import 'package:chat_app/components/userTile.dart';
import 'package:chat_app/services/auth/data.dart';
import 'package:chat_app/services/chat/chatService.dart';
import 'package:chat_app/services/chat/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class BuildUserslist extends StatefulWidget {
  final String? query;
  final bool? block;
  const BuildUserslist({super.key, this.query, this.block});

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
      stream: _chatservice.getUsersStream(
          query: widget.query?.trim().toLowerCase()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Icon(Icons.error_outline_outlined);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitPulse(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          );
        }
        usersList = snapshot.data!
            .map<Widget>((userdata) => UserTile(
                onDelete: currentRoute == 'Home'
                    ? () async {
                        await removeChat(user.uid, userdata['uid']);
                      }
                    : currentRoute == 'Contacts'
                        ? () async {
                            await removeContact(user.uid, userdata['uid']);
                          }
                        : null,
                user: userdata,
                onTap: () => context.pushNamed('Chat', extra: userdata)))
            .toList();
        return usersList.isNotEmpty
            ? ListView(children: usersList)
            : Center(
                child: Icon(Icons.bubble_chart),
              );
      },
    );
  }
}
