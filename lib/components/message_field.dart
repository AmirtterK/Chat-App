import 'package:chat_app/services/auth/data.dart';
import 'package:flutter/material.dart';

class MessageField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecure;
  final FocusNode typeFocus;
  final Function()? onTap;
  const MessageField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obsecure,
    required this.onTap,
    required this.typeFocus,
  });

  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  bool isHidden = true;
  bool send = false;
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 80),
      child: Scrollbar(
        controller: _scrollController,
        child: TextField(
          maxLines: null,
          minLines: null,
          focusNode: widget.typeFocus,
          obscureText: widget.obsecure && (isHidden || !showLogin),
          controller: widget.controller,
          onChanged: (value) => setState(() {
            send = value.trim().isNotEmpty;
          }),
          decoration: InputDecoration(
            suffixIcon: send
                ? IconButton(
                    onPressed: widget.onTap,
                    icon: Icon(
                      Icons.send_rounded,
                    ),
                  )
                : null,
            hintText: widget.hintText,
            fillColor: Theme.of(context).colorScheme.secondaryFixed,
            filled: true,
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
      ),
    );
  }
}
