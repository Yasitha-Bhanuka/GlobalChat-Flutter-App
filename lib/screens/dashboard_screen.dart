import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/screens/profile_screen.dart';
import 'package:globalchat/screens/splash_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var user = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;

  List<Map<String, dynamic>> chatRoomsList = [];

  void getChatRooms() {
    db.collection("chatrooms").get().then((dataSnapshot) {
      for (var singleChatRoom in dataSnapshot.docs) {
        chatRoomsList.add(singleChatRoom.data());
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Global Chat")),
        drawer: Drawer(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                ListTile(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut(); // logout
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) {
                      return SplashScreen();
                    }), (route) => false);
                  },
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                ),
                ListTile(
                  onTap: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProfileScreen();
                    }));
                  },
                  leading: Icon(Icons.people),
                  title: Text("Profile"),
                )
              ],
            ),
          ),
        ),
        body: ListView.builder(
            itemCount: chatRoomsList.length,
            itemBuilder: (BuildContext context, int index) {
              String chatRoomName = chatRoomsList[index]["chatroom_name"] ?? "";

              return ListTile(
                leading: CircleAvatar(child: Text(chatRoomName[0])),
                title: Text(chatRoomsList[index]["chatroom_name"] ?? ""),
                subtitle: Text(chatRoomsList[index]["desc"] ?? ""),
              );
            }));
  }
}
