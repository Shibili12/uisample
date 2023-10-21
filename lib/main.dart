import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uisample/firebase_options.dart';
import 'package:uisample/firebase_services/firebasenotification.dart';

import 'package:uisample/pages/loginpage.dart';
import 'package:uisample/pages/notificationpage.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firebasenotification().initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Loginpage(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      routes: {
        '/notification_screen': (context) => const NotificationPage(),
      },
    );
  }
}
