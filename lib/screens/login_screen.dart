import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String login_mail = '', login_password = '';
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
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  login_mail = value;
                },
                decoration:
                    kTextDecoration.copyWith(hintText: 'Enter your Email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  login_password = value;
                },
                decoration:
                    kTextDecoration.copyWith(hintText: 'Enter Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Login',
                colour: Colors.lightBlueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                    errorMessage = '';
                  });
                  if (login_mail.isEmpty || login_password.isEmpty) {
                    errorMessage = 'Fill all Details';
                    setState(() {
                      showSpinner = false;
                    });
                  } else {
                    try {
                      final credential = await _auth.signInWithEmailAndPassword(
                          email: login_mail, password: login_password);
                      if (credential != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                        errorMessage = '';
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        showSpinner = false;
                        if (e.code == 'user-not-found') {
                          errorMessage = 'No user found for that email.';
                        } else if (e.code == 'wrong-password') {
                          errorMessage =
                              'Wrong password provided for that user.';
                        } else {
                          errorMessage = 'An Error occured. Please Try again.';
                        }
                      });
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
