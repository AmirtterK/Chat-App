import 'package:chat_app/components/buildUsersList.dart';
import 'package:chat_app/components/drawer.dart';
import 'package:chat_app/components/searchDelegate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text('Home'),
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context,
              delegate: SSearchDelegate(),
            ),
            icon: Icon(Icons.search),
          ),
        ],
      ),
      drawer: HomeDrawer(),
      body: BuildUserslist(),
    );
  }
}
