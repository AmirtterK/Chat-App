import 'package:chat_app/components/buildUserInput.dart';
import 'package:chat_app/components/chatBubble.dart';
import 'package:chat_app/components/userAvatar.dart';
import 'package:chat_app/services/chat/chatService.dart';
import 'package:chat_app/services/chat/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:popover/popover.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const ChatPage({
    super.key,
    required this.user,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _message_controller = TextEditingController();
  final Chatservice _chatservice = Chatservice();
  final FocusNode _typeFocus = FocusNode();
  final ScrollController _scorllController = ScrollController();
  bool? userSentLast;
  @override
  void initState() {
    super.initState();
    _typeFocus.addListener(() {
      if (_typeFocus.hasFocus) {
        Future.delayed(
          Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _typeFocus.dispose();
  }

  void scrollDown({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scorllController.hasClients) return;

      final position = _scorllController.position.maxScrollExtent;
      if (animated) {
        _scorllController.animateTo(
          position,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
      } else {
        _scorllController.jumpTo(position);
      }
    });
  }

  void sendMessage() {
    if (_message_controller.text.isNotEmpty) {
      _chatservice.sendMessage(
          widget.user['uid'], _message_controller.text.trimRight());
      _message_controller.clear();
      scrollDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        surfaceTintColor: const Color(0x00000000),
        title: Row(
          children: [
            UserAvatar(
              name: widget.user['username'],
              radius: 17,
              color: widget.user['color'],
            ),
            // CircleAvatar(
            //   radius: 15,
            //   backgroundImage: avatarImage == null
            //       ? AssetImage('assets/avatar.jpg')
            //       : FileImage(avatarImage!),
            // ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.user['username'],
              overflow: TextOverflow.fade,
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (contactContext) {
              return IconButton(
                onPressed: () async => contactOptions(contactContext),
                icon: Icon(Icons.more_vert_outlined),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          Builduserinput(
            messageController: _message_controller,
            typeFocus: _typeFocus,
            sendMessage: sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
      stream: _chatservice.getMessage(widget.user['uid'], senderId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: SpinKitPulse(color: Colors.white),
          );
        }

        if (snapshot.hasError) return Text('Error');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SpinKitPulse(color: Colors.white);
        }

        WidgetsBinding.instance
            .addPostFrameCallback((_) => scrollDown(animated: false));
        final docs = snapshot.data!.docs;
        return ListView.builder(
          controller: _scorllController,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final currentDoc = docs[index];
            final currentSenderId = currentDoc['senderId'];
            final isCurrentUser = currentSenderId == senderId;

            bool showAvatar = false;
            if (!isCurrentUser) {
              bool isLast = index == docs.length - 1;
              bool nextIsDifferentSender =
                  !isLast && docs[index + 1]['senderId'] != currentSenderId;
              if (isLast || nextIsDifferentSender) {
                showAvatar = true;
              }
            }
            return _buildMessageItem(currentDoc, isCurrentUser, showAvatar);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(
      DocumentSnapshot doc, bool isCurrentUser, bool showAvatar) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (showAvatar)
              Container(
                  margin: EdgeInsets.only(left: 10),
                  child: UserAvatar(
                    name: widget.user['username'],
                    radius: 20,
                    color: widget.user['color'],
                  )
                  // child: CircleAvatar(
                  //   radius: 20,
                  //   backgroundImage: avatarImage == null
                  //       ? AssetImage('assets/avatar.jpg')
                  //       : FileImage(avatarImage!),
                  // ),
                  )
            else if (!isCurrentUser)
              SizedBox(
                width: 50,
              ),
            Flexible(
              child: Builder(
                builder: (Bubblecontext) {
                  return Chatbubble(
                    onLongPress: () async {
                      messageOptions(Bubblecontext, isCurrentUser,
                          data['timestamp'], data['message']);
                    },
                    isCurrentUser: isCurrentUser,
                    message: data['message'],
                    showAvatar: showAvatar,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> messageOptions(BuildContext bubblecontext, bool isCurrentUser,
      Timestamp timestamp, String message) async {
    _typeFocus.unfocus();
    showPopover(
      arrowWidth: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      width: 150,
      context: bubblecontext,
      bodyBuilder: (context) => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Theme.of(context).colorScheme.surface,
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Opacity(
                      opacity: 0.8,
                      child: Text(DateFormat.Hm().format(timestamp.toDate())))),
            ),
            Material(
              color: Theme.of(context).colorScheme.surface,
              child: InkWell(
                onTap: () async => {
                  Navigator.of(context).pop(),
                  Clipboard.setData(ClipboardData(text: message))
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.copy_outlined,
                        size: 20,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text('Copy'),
                    ],
                  ),
                ),
              ),
            ),
            if (isCurrentUser)
              Material(
                color: Theme.of(context).colorScheme.surface,
                child: InkWell(
                  onTap: () async => {
                    Navigator.of(context).pop(),
                    await _chatservice.deleteMessage(
                        widget.user['uid'], timestamp)
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline_outlined,
                          size: 20,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> contactOptions(BuildContext contactContext) async {
    _typeFocus.unfocus();
    bool userIsContact = await isContact(
        FirebaseAuth.instance.currentUser!.uid, widget.user['uid']);
    if (mounted && context.mounted) {
      showPopover(
        arrowWidth: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        width: 190,
        context: contactContext,
        bodyBuilder: (context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: Theme.of(context).colorScheme.surface,
                child: InkWell(
                  onTap: () async => {
                    Navigator.of(context).pop(),
                    userIsContact
                        ? await removeContact(
                            FirebaseAuth.instance.currentUser!.uid,
                            widget.user['uid'])
                        : await addContact(
                            FirebaseAuth.instance.currentUser!.uid,
                            widget.user['uid'])
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      children: [
                        Icon(
                          userIsContact ? Icons.delete : Icons.add_outlined,
                          size: 20,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(userIsContact ? 'Remove Contact' : 'Add Contact'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
