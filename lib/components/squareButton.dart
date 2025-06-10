import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  final String path;
    final Function()? onTap;

  const SquareButton({
    super.key,
    required this.path, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
      color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          borderRadius: BorderRadius.circular(16),
      color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
        child: Center(
          child: Image.asset(
            path,
            height: 35,
          ),
        ),
      ),
    );
  }
}
