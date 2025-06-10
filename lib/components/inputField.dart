import 'package:chat_app/services/auth/data.dart';
import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecure;
    final Function(String)? onChanged;

  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obsecure, this.onChanged,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool isHidden = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      obscureText: widget.obsecure && (isHidden || !showLogin),
      controller: widget.controller,
      decoration: InputDecoration(
        suffixIcon: widget.obsecure && showLogin
            ? IconButton(
                onPressed: () => setState(() {
                  isHidden = !isHidden;
                }),
                icon: Icon(
                  isHidden
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              )
            : null,
        hintText: widget.hintText,
        fillColor: Theme.of(context).colorScheme.tertiary,
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[500]),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
          ),
        ),
      ),
    );
  }
}
