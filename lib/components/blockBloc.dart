import 'package:flutter/material.dart';

class Blockbloc extends StatelessWidget {
  final String username;
  final Function()? onTap;

  const Blockbloc({super.key, required this.username, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondaryFixed,
      width: double.infinity,
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            onTap != null
                ? "You've blocked this account"
                : "You've been blocked by this account",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "You can't message with $username",
            style: TextStyle(color: Colors.grey[600]),
          ),
          if (onTap != null)
            Material(
              color: Theme.of(context).colorScheme.secondaryFixed,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'Unblock',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
