import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/screens/splash_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var user = FirebaseAuth.instance.currentUser;

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
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Welcome ${(user?.email ?? "").toString()}"),
          ],
        ),
      ),
    );
  }
}
