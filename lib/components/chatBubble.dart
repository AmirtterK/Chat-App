import 'package:flutter/material.dart';

class Chatbubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final bool showAvatar;
  final Function()? onLongPress;

  const Chatbubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.showAvatar,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    Radius raduis = Radius.circular(10);
    Radius raduisZero = Radius.circular(2);
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.only(
          right: isCurrentUser ? 10 : MediaQuery.of(context).size.width * 0.22,
          left: !isCurrentUser ? 10 : MediaQuery.of(context).size.width * 0.22,
          top: 5,
          bottom: 5,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.onSecondaryFixed,
          borderRadius: BorderRadius.only(
            topLeft: raduis,
            topRight: raduis,
            bottomLeft: isCurrentUser ? raduis : raduisZero,
            bottomRight: !isCurrentUser ? raduis : raduisZero,
          ),
        ),
        child: Text(message),
      ),
    );
  }
}
