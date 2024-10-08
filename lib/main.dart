import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:globalchat/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that the Flutter engine is initialized before initializing Firebase.

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions
          .currentPlatform); // Initialize Firebase with the default options for the current platform.

  runApp(ChangeNotifierProvider(
      create: (context) => UserProvider(), child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // when the theme is dark, the text color will be white. we cant use ThemeData.dark() because it will change the background color to black.
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: SplashScreen(),
    );
  }
}
