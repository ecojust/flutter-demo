import 'package:flutter/material.dart';
import 'package:flutter_githubaction/screens/home_screen.dart';
import 'package:flutter_githubaction/screens/second_screen.dart';
import 'package:flutter_githubaction/services/fcm_service.dart';
import 'package:flutter_githubaction/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local notifications
  await NotificationService.initializeNotification();

  // initialize FCM
  await FcmService.initializeFCM();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Demo',
      routes: {
        'home': (context) => const HomeScreen(),
        'second': (context) => const SecondScreen(),
      },
      initialRoute: 'home',
      navigatorKey: navigatorKey,
    );
  }
}