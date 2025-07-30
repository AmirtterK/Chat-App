import 'package:chat_app/pages/authPage.dart';
import 'package:chat_app/pages/blockPage.dart';
import 'package:chat_app/pages/chatPage.dart';
import 'package:chat_app/pages/contactsPage.dart';
import 'package:chat_app/pages/homePage.dart';
import 'package:chat_app/pages/settingsPage.dart';
import 'package:chat_app/services/animations/animations.dart';
import 'package:chat_app/services/chat/firebaseApi.dart';
import 'package:chat_app/services/theme/themeprovider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'services/auth/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top], // Show only the status bar
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebaseapi().initNotifications();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      _handleMessage(message);
    });

    _messaging.getInitialMessage().then((message) {
      if (message != null) {
        _handleMessage(message);
      }
    });
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    final data = message.data;
    _router.pushNamed('Chat', extra: data);
  }

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
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      name: 'Auth',
      path: '/',
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      name: 'Home',
      path: '/Home',
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
    GoRoute(
      name: 'Chat',
      path: '/Chat',
      pageBuilder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          key: state.pageKey,
          child: ChatPage(user: args),
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
