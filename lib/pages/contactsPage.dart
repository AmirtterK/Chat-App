import 'package:chat_app/components/buildUsersList.dart';
import 'package:chat_app/services/auth/data.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          currentRoute = 'Home';
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Contacts'),
        ),
        body: BuildUserslist(),
      ),
    );
  }
}
