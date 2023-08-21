
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:zeggy_chat/constants.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {

  //The static keyword helps to create a class wise variable
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
 String messageText;
 final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  //This method gets the current user
  void getCurrentUser() async{
    try{
    //obtains the user details
    final user = await _auth.currentUser;

    //check if the user detail is not empty
    if(user != null) {
      loggedInUser = user;
      print(loggedInUser.email);
    }
    }catch(e){
      print(e);
    }
  }

  //This method will retrieve data from the cloudfire store to the chatscreen
 // void getMessages() async{
 //    //This retrieve the data in the messages collection in form of map document
 //    final messages = await _fireStore.collection('messages').get();
 //    //looping through with a for loop
 //    for(var message in messages.docs){
 //      print(message.data());
 //    }
 //  }

 // void messagesStream() async{
 //   await for(var snapshots in _fireStore.collection('messages').snapshots()){
 //     for(var message in snapshots.docs){
 //       print(message.data());
 //     }
 //   }
 // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //messagesStream();
                //getMessages();
                //This will sign out the user
                // _auth.signOut();
                // Navigator.pop(context);

              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              //Note the property "stream" is the source of data
              stream: _fireStore.collection('messages').snapshots(),
              builder: (context, snapshot){
                //This should happen if the snapshot has no data
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  ),);
                }
                //This is a list of snapshot document and
                //This happens if the snapshot has data
                  final messages = snapshot.data.docs;
                  //Creates a list of text widgets
                  List<Text> messageWidgets = [];
                  //Loops through messages
                  for(var message in messages){
                    final messageText = message['text'];
                    final messageSender = message['sender'];
                    final messageWidget = Text('$messageText from $messageSender');
                    messageWidgets.add(messageWidget);
                  }
                  return Column(children: messageWidgets,);

              }
              ),
               Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          //Any message entered in the chatScreen becomes message text
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //Implement send functionality.

                        _fireStore.collection('messages').add({
                          'text': messageText,
                          'sender': loggedInUser.email
                        });

                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),

          ],
        ),
      ),
    );
  }
}
