import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String userName = "";
  String userCountry = "";
  String usereEmail = "";
  String userId = "";

  var db = FirebaseFirestore.instance;
  var authUser = FirebaseAuth.instance.currentUser;
  void getUserDetails() async {
    var user = await db
        .collection("users")
        .doc(authUser!.uid)
        .get()
        .then((dataSnapshot) {
      userName = dataSnapshot.data()?["name"] ?? "";
      userCountry = dataSnapshot.data()?["country"] ?? "";
      usereEmail = dataSnapshot.data()?["email"] ?? "";
      userId = dataSnapshot.data()?["id"] ?? "";
      notifyListeners();
    });
  }
}
