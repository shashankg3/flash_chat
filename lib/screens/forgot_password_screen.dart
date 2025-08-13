import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String id = 'forgot_password_screen';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _auth = FirebaseAuth.instance;
  late String email = '';
  bool showSpinner = false;
  String infoMessage = '';

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
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kTextDecoration.copyWith(hintText: 'Enter your Email'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Send Reset Email',
                colour: Colors.lightBlueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                    infoMessage = '';
                  });
                  if (email.isEmpty) {
                    infoMessage = 'Please enter your email';
                  } else {
                    try {
                      await _auth.sendPasswordResetEmail(email: email);
                      infoMessage = 'Password reset email sent';
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        infoMessage = 'No user found for that email.';
                      } else {
                        infoMessage =
                            'An error occurred. Please try again later.';
                      }
                    }
                  }
                  setState(() {
                    showSpinner = false;
                  });
                  if (infoMessage.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Color(0xFF333333),
                      content: Text(
                        infoMessage,
                        style: TextStyle(color: Colors.white),
                      ),
                      action: SnackBarAction(
                        label: 'Dismiss',
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .hideCurrentSnackBar();
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
