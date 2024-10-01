import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that the Flutter engine is initialized before initializing Firebase.

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions
          .currentPlatform); // Initialize Firebase with the default options for the current platform.

  runApp(MyApp());
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
      title: 'Global Chat',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Global Chat'),
        ),
        body: const Center(
          child: Text('Welcome to Global Chat!'),
        ),
      ),
    );
  }
}
