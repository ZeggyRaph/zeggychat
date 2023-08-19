import 'package:flutter/material.dart';
import 'package:zeggy_chat/components/rounded_button.dart';
import 'package:zeggy_chat/constants.dart';
class RegistrationScreen extends StatefulWidget {

  //The static keyword helps to create a class wise variable
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
              unpressed: () {
        //Implement registration functionality.
                print(email);
                print(password);
      },)
          ],
        ),
      ),
    );
  }
}
