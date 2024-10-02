import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String userName = "";
  String userCountry = "";
  String userEmail = "";
  String userId = "";

  var db = FirebaseFirestore.instance;
  void getUserDetails() async {
    var authUser = FirebaseAuth.instance.currentUser;
    var user = await db
        .collection("users")
        .doc(authUser!.uid)
        .get()
        .then((dataSnapshot) {
      userName = dataSnapshot.data()?["name"] ?? "";
      userCountry = dataSnapshot.data()?["country"] ?? "";
      userEmail = dataSnapshot.data()?["email"] ?? "";
      userId = dataSnapshot.data()?["id"] ?? "";
      notifyListeners();
    });
  }

  void updateUserName(String newName) {
    userName = newName;
    notifyListeners();
  }
}
