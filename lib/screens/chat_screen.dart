import 'package:flutter/material.dart';
import 'package:zeggy_chat/constants.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  //The static keyword helps to create a class wise variable
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
 String messageText;
 final _auth = FirebaseAuth.instance;
  User loggedInUser;

  @override
  void initState() {
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
            MessageStream(),
               Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          //Any message entered in the chatScreen becomes message text
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //When a user enters message in the textfield and presses the send button,
                        // this clears the text from the textfield once the message has been sent
                        messageTextController.clear();

                        //This adds a new message into the chatScreen
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

//Refactored the streamBuilder
class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
          //Creates a list of messageBubble widgets
          List<MessageBubble> messageWidgets = [];
          //Loops through messages
          for(var message in messages){
            final messageText = message['text'];
            final messageSender = message['sender'];

            //Refactored the Text widget for special styling
            final messageBubble = MessageBubble(
              text: messageText,sender: messageSender,);
            messageWidgets.add(messageBubble);
          }
          //Using a listview so as to make scrollable
          //And wrapping the listview inside and expanded widget so that
          // It does occupy all the space
          return Expanded(
              child:
              ListView(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20.0),
                children: messageWidgets,));

        }
    );
  }
}


//Refactored the message texts
class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender});
  final text;
  final sender;


  @override
  Widget build(BuildContext context) {
    //wrapping the text widget with material widget so that more styling can be done
    //padding the material widget to separate the each text in the chatScreen.
    return Padding(
      padding:  EdgeInsets.all(10.0),
      child: Column(
        //sending the chat text to the far right
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(sender,style: TextStyle(
          fontSize: 12.0,
          color: Colors.black54),),
          Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.lightBlueAccent,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Text(text,
            style: TextStyle(
              fontSize: 15.0,
            color: Colors.white),),
        ),
      ),],),
    );
  }
}
