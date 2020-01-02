import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/models/chat.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:float/widgets/list_of_chats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatOverviewScreen extends StatelessWidget {
  static const String id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    var loggedInUser = Provider.of<FirebaseUser>(context);

    return FutureBuilder(
        future: FirebaseConnection.getChats(loggedInUser: loggedInUser?.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CupertinoActivityIndicator());
          }
          if (snapshot.hasError) {
            return Container(
              color: Colors.red,
              child: Text('Something went wrong on chat overview screen'),
            );
          }
          if (!snapshot.hasData) {
            return Container(color: Colors.white);
          }
          List<Chat> chats =
              List.from(snapshot.data); // to convert it to editable list
          chats.sort((chat1, chat2) => (chat2.lastMessageTimestamp)
              .compareTo(chat1.lastMessageTimestamp));

          return ListOfChats(
            chats: chats,
          );
        });
  }
}
