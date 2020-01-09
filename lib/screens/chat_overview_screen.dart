import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/chat.dart';
import 'package:float/screens/splash_screen.dart';
import 'package:float/services/firebase_cloud_firestore_service.dart';
import 'package:float/widgets/list_of_chats.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatOverviewScreen extends StatelessWidget {
  static const String id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    final loggedInUser = Provider.of<FirebaseUser>(context, listen: false);
    if (loggedInUser == null) {
      return Center(
        child: RoundedButton(
          text: 'Signin',
          color: kDarkGreenColor,
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<void>(
                builder: (context) {
                  return SplashScreen();
                },
              ),
            );
          },
        ),
      );
    }

    return StreamBuilder(
        stream:
            cloudFirestoreService.getChatStream(loggedInUid: loggedInUser?.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
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
