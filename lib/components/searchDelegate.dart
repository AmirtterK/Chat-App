import 'package:chat_app/components/buildUsersList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SSearchDelegate extends SearchDelegate {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () => showResults(context), icon: Icon(Icons.search)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null), icon: Icon(Icons.arrow_back));
  }
 
  @override
  Widget buildResults(BuildContext context) {
    return BuildUserslist(query: query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SizedBox();
  }
}
