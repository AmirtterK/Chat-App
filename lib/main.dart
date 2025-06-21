import 'package:chat_app/pages/authPage.dart';
import 'package:chat_app/pages/blockPage.dart';
import 'package:chat_app/pages/contactsPage.dart';
import 'package:chat_app/pages/homePage.dart';
import 'package:chat_app/pages/settingsPage.dart';
import 'package:chat_app/services/animations/animations.dart';
import 'package:chat_app/services/chat/firebaseApi.dart';
import 'package:chat_app/services/theme/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'services/auth/firebase_options.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebaseapi().initNotifications();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget { 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/Auth',
  routes: <RouteBase>[
    GoRoute(
      name: 'Auth',
      path: '/Auth',
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      name: 'Home',
      path: '/Home',
      builder: (context, state) => const HomePage(),
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          key: state.pageKey,
          child: const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: fadeInTransition.animate(animation),
            child: AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: slideInTransition2.evaluate(animation),
                  child: child,
                );
              },
              child: child,
            ),
          ),
        );
      },
    ),
    GoRoute(
      name: 'Contacts',
      path: '/Contacts',
      builder: (context, state) => const ContactsPage(),
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          key: state.pageKey,
          child: const ContactsPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: fadeInTransition.animate(animation),
            child: AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: slideInTransition2.evaluate(animation),
                  child: child,
                );
              },
              child: child,
            ),
          ),
        );
      },
    ),
    GoRoute(
      name: 'Settings',
      path: '/Settings',
      builder: (context, state) => const SettingsPage(),
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          key: state.pageKey,
          child: const SettingsPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: fadeInTransition.animate(animation),
            child: AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: slideInTransition2.evaluate(animation),
                  child: child,
                );
              },
              child: child,
            ),
          ),
        );
      },
    ),
    GoRoute(
      name: 'Block',
      path: '/Block',
      builder: (context, state) => const BlockPage(),
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          key: state.pageKey,
          child: const BlockPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: fadeInTransition.animate(animation),
            child: AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: slideInTransition2.evaluate(animation),
                  child: child,
                );
              },
              child: child,
            ),
          ),
        );
      },
    ),
  ],
);
