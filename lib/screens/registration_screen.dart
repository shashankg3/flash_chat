import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String uname = '', password = '';
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  uname = value;
                },
                decoration:
                    kTextDecoration.copyWith(hintText: 'Enter your Email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              Focus(
                onFocusChange: (hasFocus) {
                  if (hasFocus) {
                    // Show the additional information when the password field is focused
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Color(0xFF333333),
                      content: Text(
                        style: TextStyle(color: Colors.white),
                        'Password must be minimum 8 characters long and should contain at least 1 digit.',
                      ),
                      duration: Duration(seconds: 3),
                    ));
                  }
                },
                child: TextField(
                  obscureText: true,
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextDecoration.copyWith(
                    hintText: 'Enter your Password',
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              RoundedButton(
                title: 'Register',
                colour: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  if (uname.isEmpty || password.isEmpty) {
                    errorMessage = 'Fill all Details';
                  } else if (!isEmailValid(uname)) {
                    errorMessage = 'Invalid Email';
                  } else if (!isPasswordValid(password)) {
                    errorMessage = 'Invalid Password';
                  } else {
                    try {
                      final newuser =
                          await _auth.createUserWithEmailAndPassword(
                        email: uname,
                        password: password,
                      );
                      Navigator.pushNamed(context, ChatScreen.id);
                      errorMessage = '';
                    } on FirebaseAuthException catch (e) {
                      if (e.code == "email-already-in-use") {
                        errorMessage = 'Email is already in use';
                      }
                    }
                  }
                  if (errorMessage.isNotEmpty) {
                    setState(() {
                      showSpinner = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Color(0xFF333333),
                      content: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.white),
                      ),
                      action: SnackBarAction(
                        label: 'Dismiss',
                        onPressed: () {
                          // Some code to undo the change.
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                    ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

bool isEmailValid(String email) {
  // Regular expression for email validation
  final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

bool isPasswordValid(String password) {
  // Regular expression for password validation
  final passwordRegex =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#$%^&*()-_=+]{8,}$');
  return passwordRegex.hasMatch(password);
}
