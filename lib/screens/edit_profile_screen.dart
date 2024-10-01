import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/provider/user_provider.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Map<String, dynamic> userData = {};

  var db = FirebaseFirestore.instance;

  TextEditingController nameText = TextEditingController();

  var editProfileFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    nameText.text = Provider.of<UserProvider>(context, listen: false).userName;
    super.initState();
  }

  void updateData() {
    Map<String, dynamic> dataToUpdate = {
      "name": nameText.text,
    };

    db
        .collection("users")
        .doc(Provider.of<UserProvider>(context, listen: false).userId)
        .update(dataToUpdate);

    Provider.of<UserProvider>(context, listen: false).getUserDetails();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            // change profile picture
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Edit Profile"),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              if (editProfileFormKey.currentState!.validate()) {
                // update of the data on database
                updateData();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.check),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity, // full width
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: editProfileFormKey,
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name cannot be empty";
                    }
                  },
                  controller: nameText,
                  decoration: InputDecoration(
                    labelText: "Name",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
