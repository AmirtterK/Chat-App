import 'package:chat_app/components/userAvatar.dart';
import 'package:chat_app/services/auth/data.dart';
import 'package:chat_app/services/chat/chatService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UserTile extends StatelessWidget {
  final Map<String, dynamic> user;
  final void Function()? onTap;
  final void Function()? onDelete;
  final Chatservice _chatservice = Chatservice();

  UserTile({
    super.key,
    this.onTap,
    this.onDelete,
    required this.user,
  });
  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: onDelete != null,
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: BehindMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.red,
            label: 'Delete',
            onPressed: (context) => onDelete?.call(),
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
          subtitle: StreamBuilder(
            stream: _chatservice.getLastMessage(userData!['uid'], user['uid']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox();
              }
              if (!snapshot.hasData ||
                  snapshot.hasError ||
                  snapshot.data!.isEmpty ||
                  currentRoute != 'Home') {
                return SizedBox();
              } else {
                final message = snapshot.data!;
                bool iSent = message['senderId'] == userData!['uid'];
                return StreamBuilder(
                    stream: Stream.periodic(Duration(minutes: 1)),
                    builder: (context, _) {
                      return Opacity(
                        opacity: !iSent && message['seen'] ? 0.8 : 1,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 200),
                              child: Text(
                                iSent
                                    ? message['seen']
                                        ? 'Seen'
                                        : 'Sent'
                                    : message['message'] ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontWeight: iSent
                                      ? FontWeight.normal
                                      : message['seen']
                                          ? FontWeight.normal
                                          : FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              iSent
                                  ? ''
                                  : _chatservice
                                      .timeSinceSent(message['timestamp']),
                              style: TextStyle(
                                fontWeight: iSent
                                    ? FontWeight.normal
                                    : message['seen']
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }
            },
          ),
        ),
      ),
    );
  }
}
