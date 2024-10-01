import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                label: Text("Email"),
              ),
            ),
            SizedBox(
              height: 23,
            ),
            TextField(
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                label: Text("Password"),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(onPressed: () {}, child: Text("Create an account"))
          ],
        ),
      ),
    );
  }
}
