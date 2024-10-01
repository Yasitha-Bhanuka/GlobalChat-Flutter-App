import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/screens/splash_screen.dart';

class LoginController {
  static Future<void> login(
      {required BuildContext context,
      required String emailController,
      required String passwordController}) async {
    try {
      // create account
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController, password: passwordController);

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return SplashScreen();
      }), (route) => false);

      print("Account login successfully");
    } catch (e) {
      SnackBar messageSnackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(e.toString()),
      );

      ScaffoldMessenger.of(context).showSnackBar(messageSnackBar);

      print(e);
    }
  }
}
