import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/screens/dashboard_screen.dart';

class SignupController {
  static Future<void> createAccount(
      {required BuildContext context,
      required String emailController,
      required String passwordController,
      required String nameController,
      required String countryController}) async {
    try {
      // create account
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController, password: passwordController);

      var userId = FirebaseAuth.instance.currentUser!
          .uid; // get user id from firebase auth instance and store it in userId variable. ! is used to check if the user is not null and then get the uid from it. If the user is null, it will throw an error.
      var db = FirebaseFirestore.instance; // get firestore instance

      // create a map of data to store in the users collection
      Map<String, dynamic> data = {
        "name": nameController,
        "country": countryController,
        "email": emailController,
        "id": userId
      };

      try {
        // store the data in the users collection in firestore
        await db.collection("users").doc(userId.toString()).set(data);
      } catch (e) {
        print(e);
      }

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return DashboardScreen();
      }), (route) => false);

      print("Account is created successfully");
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
