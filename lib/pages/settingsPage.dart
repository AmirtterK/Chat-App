import 'package:chat_app/components/drawer.dart';
import 'package:chat_app/services/auth/data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        title: Text('settings'),
      ),
      body: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            leading: Icon(Icons.block_flipped),
            title: Text('Blocked'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (userData!['block'] as List).length.toString(),
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward_ios_rounded),
              ],
            ),
            onTap: () => {context.pushNamed('Block'), setState(() {})},
          )
        ],
      ),
    );
  }
}
