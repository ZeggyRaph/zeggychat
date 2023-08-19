import 'package:flutter/material.dart';
import 'package:zeggy_chat/components/rounded_button.dart';
import 'package:zeggy_chat/constants.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:zeggy_chat/screens/chat_screen.dart';


class RegistrationScreen extends StatefulWidget {

  //The static keyword helps to create a class wise variable
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                //User entered value becomes email
                email = value;
              },
              decoration:kTextFieldDecoration.copyWith(
                  hintText:'Enter your email',
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              obscureText: true,
              onChanged: (value) {
                //User entered value becomes password
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password',
              ),
              ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              title: 'Register',
              colour: Colors.blueAccent,
              unpressed: () async{
        //Implementing the firebase functionality to authenticate users email and password
                try {
                  //registers new user
                  final newuser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  //check if user has enter his details, then take the user to chat screen
                  if(newuser != null){
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                }catch(e){
                  print(e);
                };
      },)
          ],
        ),
      ),
    );
  }
}
