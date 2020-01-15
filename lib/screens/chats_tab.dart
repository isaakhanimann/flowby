import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/chat.dart';
import 'package:float/models/helper_functions.dart';
import 'package:float/screens/chat_screen.dart';
import 'package:float/screens/choose_signup_or_login_screen.dart';
import 'package:float/services/firebase_cloud_firestore_service.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    //listening to loggedInUser (so it rebuilds) is not necessary as the navigationscreen provides it and always has the up to date value because it is rebuilt whenever we navigate to it
    final loggedInUser = Provider.of<FirebaseUser>(context, listen: false);
    if (loggedInUser == null) {
      return Center(
        child: RoundedButton(
          text: 'Sign In',
          color: kDarkGreenColor,
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<void>(
                builder: (context) {
                  return ChooseSignupOrLoginScreen();
                },
              ),
            );
          },
        ),
      );
    }

    return StreamBuilder(
        stream:
            cloudFirestoreService.getChatStream(loggedInUid: loggedInUser.uid),
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

          if (chats.isEmpty) {
            // Scaffold damit text nicht gelb unterstrichen ist
            return CupertinoPageScaffold(
              child: Center(
                child: Text('You have no open chats', style: kSkillTextStyle),
              ),
            );
          }
          return CustomScrollView(
            semanticChildCount: chats.length,
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: Text('Chats'),
              ),
              SliverSafeArea(
                top: false,
                sliver: SliverFixedExtentList(
                  itemExtent: 90,
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < chats.length) {
                        return ChatItem(
                          chat: chats[index],
                        );
                      }
                      return null;
                    },
                    childCount: chats.length,
                  ),
                ),
              )
            ],
          );
        });
  }
}

class ChatItem extends StatelessWidget {
  final Chat chat;

  ChatItem({@required this.chat});

  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<FirebaseUser>(context, listen: false);
    bool user1IsLoggedInUser = (chat.uid1 == loggedInUser.uid);
    String otherUid = user1IsLoggedInUser ? chat.uid2 : chat.uid1;
    String otherUsername =
        user1IsLoggedInUser ? chat.username2 : chat.username1;
    String otherImageFileName =
        user1IsLoggedInUser ? chat.user2ImageFileName : chat.user1ImageFileName;
    final heroTag = otherUid + 'chats';

    return Card(
      elevation: 0,
      color: kLightGrey2,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Center(
        child: ListTile(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<void>(
                builder: (context) {
                  return ChatScreen(
                    loggedInUid: loggedInUser.uid,
                    otherUid: otherUid,
                    otherUsername: otherUsername,
                    otherImageFileName: otherImageFileName,
                    heroTag: heroTag,
                    chatPath: chat.chatpath,
                  );
                },
              ),
            );
          },
          leading: Hero(
            tag: heroTag,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F$otherImageFileName?alt=media'),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                otherUsername,
                style: kUsernameTextStyle,
              ),
              Text(
                HelperFunctions.getTimestampAsString(
                    timestamp: chat.lastMessageTimestamp),
                style: TextStyle(color: Colors.black38, fontSize: 12),
              ),
            ],
          ),
          subtitle: Text(
            HelperFunctions.getDotDotDotString(
                maybeLongString: chat.lastMessageText),
            style: TextStyle(color: Colors.black38, fontSize: 15),
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ),
    );
  }
}
