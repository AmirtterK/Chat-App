import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String name;
  final double radius;
  final String color;

  const UserAvatar({
    super.key,
    required this.name,
    required this.radius,
    required this.color,
  });
  String letters(String name) {
    String newName = '';
    for (var sub in name.split(' ')) {
      if (newName.length >= 2) break;
      if (sub.isEmpty) continue;
      newName = newName + sub[0];
    }
    return newName.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius * 2,
      width: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(
          int.parse(color.substring(1), radix: 16),
        ),
      ),
      child: Center(
          child: Text(
        letters(name),
        style: TextStyle(fontSize: radius * 2 / 3),
      )),
    );
  }
}
