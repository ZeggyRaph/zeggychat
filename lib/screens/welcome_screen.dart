import 'package:flutter/material.dart';
import 'package:zeggy_chat/screens/login_screen.dart';
import 'package:zeggy_chat/screens/registration_screen.dart';
import 'package:zeggy_chat/components/rounded_button.dart';
class WelcomeScreen extends StatefulWidget {

  //The static keyword helps to create a class wise variable
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}
// we extend the welcomeStateScreen with SingleTickerProviderStateMixin
class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  //declares the animation controller
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    //Implement animation controller so that it builds once
    controller = AnimationController(
      duration: Duration(seconds: 2),
        vsync: this,
        //Increase the upperBound from 1 to 100
     // upperBound: 100,
    );
    controller.forward();
    controller.addListener(() { });
    super.initState();
  }

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
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                Text(
                  'Zeggy Chat',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(title: 'Login',
                colour:Colors.lightBlueAccent,
            unpressed: () {
              //Go to login screen.
              Navigator.pushNamed(context, LoginScreen.id);
            },),
            RoundedButton(title: 'Register',
              colour:Colors.blueAccent,
              unpressed: () {
                //Go to login screen.
                Navigator.pushNamed(context, RegistrationScreen.id);
              },),
          ],
        ),
      ),
    );
  }
}


