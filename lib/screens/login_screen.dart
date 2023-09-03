import 'package:flutter/material.dart';
import 'package:zeggy_chat/components/rounded_button.dart';
import 'package:zeggy_chat/constants.dart';
import 'chat_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {

  //The static keyword helps to create a class wise variable
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;


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
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Entered value which becomes user email
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password',),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Login',
                colour: Colors.lightBlueAccent,
                unpressed:  () async{
                  //on clicking modal progress hud should start spinning and stop once user is logged in
                  setState(() {
                    showSpinner = true;
                  });
                //Implement login functionality that logs in registered user
                  // with email and password to the chat screen
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    //check if user has entered the correct detail,
                    //take them to the chat screen
                    if(user != null){
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    //To stop modal progress hud from spinning
                    setState(() {
                      showSpinner = false;
                    });
                  }catch(e){
                    print(e);
                  }
              },),
            ],
          ),
        ),
      ),
    );
  }
}
