import 'package:chat_app/components/buildUsersList.dart';
import 'package:flutter/material.dart';

class BlockPage extends StatefulWidget {
  const BlockPage({super.key});

  @override
  State<BlockPage> createState() => _BlockPageState();
}

class _BlockPageState extends State<BlockPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Blocked Accounts')),
      body: BuildUserslist(block:true),
    );
  }
}
