import 'package:chat_app/components/userAvatar.dart';
import 'package:chat_app/services/auth/data.dart';
import 'package:chat_app/services/theme/themeprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // Future pickAvatarImage() async {
    //   final selectedImage =
    //       await ImagePicker().pickImage(source: ImageSource.gallery);
    //   if (selectedImage == null) {
    //     return;
    //   }
    //   setState(() {
    //     avatarImage = File(selectedImage.path);
    //   });
    // }

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          // onTap: () async => await pickAvatarImage(),
                          // child: CircleAvatar(
                          //   radius: 40,

                          //   // backgroundImage: avatarImage == null
                          //   //     ? AssetImage('assets/avatar.jpg')
                          //   //     : FileImage(avatarImage!),
                          // ),
                          child: UserAvatar(
                            name: userData!['username'],
                            radius: 35,
                            color: userData!['color'],
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () =>
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .toggleTheme(),
                          icon: Icon(
                            Provider.of<ThemeProvider>(context).isDarkMode
                                ? Icons.mode_night
                                : Icons.wb_sunny_sharp,
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        userData!['username'],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Opacity(
                        opacity: 0.6,
                        child: Text(
                          FirebaseAuth.instance.currentUser!.email.toString(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    switch (currentRoute) {
                      case 'Home':
                        break;
                      case 'Contacts':
                        context.pop();
                        break;
                      case 'Settings':
                        context.pop();
                        break;
                      default:
                    }
                    currentRoute = 'Home';
                  },
                  leading: Icon(Icons.home),
                  title: Text(
                    'Home',
                    style: TextStyle(letterSpacing: 2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    switch (currentRoute) {
                      case 'Contacts':
                        break;
                      case 'Home':
                        context.pushNamed('Contacts');
                        break;
                      case 'Settings':
                        context.pushReplacementNamed('Contacts');
                        break;
                      default:
                    }
                    currentRoute = 'Contacts';
                  },
                  leading: Icon(Icons.person),
                  title: Text(
                    'Contacts',
                    style: TextStyle(letterSpacing: 2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    switch (currentRoute) {
                      case 'Settings':
                        break;
                      case 'Home':
                        context.pushNamed('Settings');
                        break;
                      case 'Contacts':
                        context.pushReplacementNamed('Settings');

                        break;
                      default:
                    }
                    currentRoute = 'Settings';
                  },
                  leading: Icon(Icons.settings),
                  title: Text(
                    'Settings',
                    style: TextStyle(letterSpacing: 2),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: ListTile(
              onTap: signOut,
              leading: Icon(Icons.logout_rounded),
              title: Text(
                'Logout',
                style: TextStyle(letterSpacing: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
