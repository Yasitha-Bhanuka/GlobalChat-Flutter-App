import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/provider/user_provider.dart';
import 'package:globalchat/screens/chatroom_screen.dart';
import 'package:globalchat/screens/profile_screen.dart';
import 'package:globalchat/screens/splash_screen.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var user = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> chatRoomsList = [];
  List<String> chatRoomIds = [];

  void getChatRooms() {
    db.collection("chatrooms").get().then((dataSnapshot) {
      for (var singleChatRoom in dataSnapshot.docs) {
        chatRoomsList.add(singleChatRoom.data());
        chatRoomIds.add(singleChatRoom.id.toString());
      }
      setState(() {});
    });
  }

  void checkUserAccount() async {
    if (user != null) {
      var userDoc = await db.collection("users").doc(user!.uid).get();
      if (!userDoc.exists) {
        // User account does not exist, navigate to login page
        await FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return SplashScreen();
        }), (route) => false);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserAccount();
    getChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
            title: Text("Global Chat"),
            leading: InkWell(
              onTap: () {
                scaffoldKey.currentState!.openDrawer(); // open drawer
              },
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: CircleAvatar(
                  child: Text(userProvider.userName.isNotEmpty
                      ? userProvider.userName[0]
                      : ''),
                ),
              ),
            )),
        drawer: Drawer(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                ListTile(
                  onTap: () {
                    // logout
                  },
                  leading: CircleAvatar(
                      child: Text(userProvider.userName.isNotEmpty
                          ? userProvider.userName[0].toUpperCase()
                          : '')),
                  title: Text(
                    userProvider.userName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(userProvider.userEmail),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProfileScreen();
                    }));
                  },
                  leading: Icon(Icons.people),
                  title: Text("Profile"),
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
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatroomScreen(
                      chatroomName: chatRoomName,
                      chatroomId: chatRoomIds[index],
                    );
                  }));
                },
                leading: CircleAvatar(
                    backgroundColor: Colors.blueGrey[900],
                    child: Text(
                      chatRoomName.isNotEmpty ? chatRoomName[0] : '',
                      style: TextStyle(color: Colors.white),
                    )),
                title: Text(chatRoomsList[index]["chatroom_name"] ?? ""),
                subtitle: Text(chatRoomsList[index]["desc"] ?? ""),
              );
            }));
  }
}
