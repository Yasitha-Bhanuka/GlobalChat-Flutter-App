import 'package:flutter/material.dart';
import 'package:globalchat/controllers/login_controller.dart';
import 'package:globalchat/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var userForm = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: userForm,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: Image.asset(
                  "assets/images/logo.png",
                ),
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                },
                decoration: InputDecoration(
                  label: Text("Email"),
                ),
              ),
              SizedBox(
                height: 23,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  }
                },
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
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(0, 50),
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(255, 10, 194, 236)),
                        onPressed: () {
                          if (userForm.currentState!.validate()) {
                            // create account
                            LoginController.login(
                                context: context,
                                emailController: emailController.text,
                                passwordController: passwordController.text);
                          }
                        },
                        child: Text("Login")),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text("If don't have an account"),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen())),
                    child: Text("Signup here!",
                        style: TextStyle(
                            color: Color.fromARGB(255, 10, 194, 236),
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
