import 'package:chat_app/components/message_field.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class Builduserinput extends StatelessWidget {
  final TextEditingController messageController;
  final FocusNode typeFocus;
  final Function()? sendMessage;
  bool _emojiShowing = false;
  Builduserinput(
      {super.key,
      required this.messageController,
      required this.sendMessage,
      required this.typeFocus});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              child: MessageField(
                controller: messageController,
                typeFocus: typeFocus,
                hintText: '  Message...',
                obsecure: false,
                onTap: sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
