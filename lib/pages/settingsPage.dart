import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:chat_app/components/drawer.dart';
import 'package:chat_app/services/auth/data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with WidgetsBindingObserver {
  final StreamController<bool> switchStreamController =
      StreamController<bool>.broadcast();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkNotificationStatus();
  }

  @override
  void dispose() {
    switchStreamController.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkNotificationStatus();
    }
  }

  Future<void> _checkNotificationStatus() async {
    final result = await FirebaseMessaging.instance.getNotificationSettings();
    NotificationsAllowed =
        result.authorizationStatus == AuthorizationStatus.authorized;
    switchStreamController.add(NotificationsAllowed);
  }

  Future<void> toggleSwitch(bool status) async {
    if (status) {
      final settings = await FirebaseMessaging.instance.requestPermission();
      NotificationsAllowed =
          settings.authorizationStatus == AuthorizationStatus.authorized;
      switchStreamController.add(NotificationsAllowed);
    } else {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);

    }
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
          ),
          StreamBuilder(
              stream: switchStreamController.stream,
              initialData: NotificationsAllowed,
              builder: (context, asyncSnapshot) {
                final isOn = asyncSnapshot.data ?? false;
                return SwitchListTile(
                  title: Text('Notifications'),
                  value: isOn,
                  onChanged: (value) => toggleSwitch(value),
                );
              })
        ],
      ),
    );
  }
}
