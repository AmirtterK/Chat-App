import 'package:chat_app/components/userAvatar.dart';
import 'package:chat_app/services/chat/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UserTile extends StatelessWidget {
  final Map<String, dynamic> user;
  final void Function()? onTap;
  const UserTile({
    super.key,
    this.onTap,
    required this.user,
  });
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: BehindMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.red,
            label: 'Delete',
            onPressed: (context) =>
                removeContact(FirebaseAuth.instance.currentUser!.uid, user['uid']),
            icon: Icons.delete,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: ListTile(
          // leading: CircleAvatar(
          // radius: 20,
          // backgroundImage: avatarImage == null
          // ? AssetImage('assets/avatar.jpg')
          // : FileImage(avatarImage!),
          // ),
          leading: UserAvatar(
            name: user['username'],
            radius: 20,
            color: user['color'],
          ),
          title: Text(
            user['username'],
          ),
        ),
      ),
    );
  }
}
