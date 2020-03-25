import 'package:Flowby/constants.dart';
import 'package:Flowby/models/chat.dart';
import 'package:Flowby/models/helper_functions.dart';
import 'package:Flowby/screens/chat_screen.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/services/firebase_cloud_messaging.dart';
import 'package:Flowby/widgets/badge.dart';
import 'package:Flowby/widgets/centered_loading_indicator.dart';
import 'package:Flowby/widgets/custom_card.dart';
import 'package:Flowby/widgets/tab_header.dart';
import 'package:Flowby/widgets/profile_picture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/models/user.dart';

class ChatsTab extends StatefulWidget {
  @override
  _ChatsTabState createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  Stream<List<Chat>> chatsStream;
  FirebaseCloudFirestoreService cloudFirestoreService;
  User loggedInUser;

  @override
  void initState() {
    super.initState();
    cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    loggedInUser = Provider.of<User>(context, listen: false);
    chatsStream =
        cloudFirestoreService.getChatsStream(loggedInUid: loggedInUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    final firebaseMessaging =
        Provider.of<FirebaseCloudMessaging>(context, listen: false);
    firebaseMessaging.flutterLocalNotificationsPlugin.cancelAll();
/*
    setState(() {
      chatsStream =
          cloudFirestoreService.getChatsStream(loggedInUid: loggedInUser.uid);
    });
*/

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TabHeader(),
          Expanded(
              child: StreamBuilder(
                  stream: chatsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.connectionState == ConnectionState.none) {
                      return CenteredLoadingIndicator();
                    }
                    List<Chat> chats = List.from(
                        snapshot.data); // to convert it to editable list
                    chats.sort((chat1, chat2) => (chat2.lastMessageTimestamp)
                        .compareTo(chat1.lastMessageTimestamp));

                    if (chats.isEmpty) {
                      return Center(
                        child: Text(
                          'You have no open chats',
                          style: kCardSubtitleTextStyle,
                        ),
                      );
                    }
                    return ListView.builder(
                        itemCount: chats.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                              child: Text(
                                'Chats',
                                style: kTabTitleTextStyle,
                                textAlign: TextAlign.start,
                              ),
                            );
                          }
                          return ChatItem(
                            chat: chats[index - 1],
                          );
                        });
                  }))
        ],
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  final Chat chat;

  ChatItem({@required this.chat});

  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<User>(context, listen: false);
    bool user1IsLoggedInUser = (chat.uid1 == loggedInUser.uid);
    String otherUid = user1IsLoggedInUser ? chat.uid2 : chat.uid1;
    String otherUsername =
        user1IsLoggedInUser ? chat.username2 : chat.username1;
    String otherImageFileName =
        user1IsLoggedInUser ? chat.user2ImageFileName : chat.user1ImageFileName;
    int otherImageVersionNumber = user1IsLoggedInUser
        ? chat.user2ImageVersionNumber
        : chat.user1ImageVersionNumber;
    if (otherImageFileName == null) otherImageFileName = kDefaultProfilePicName;

    final heroTag = otherUid + 'chats';

    bool amIUser1 = chat.uid1 == loggedInUser.uid;
    bool haveIBlocked;
    bool hasOtherBlocked;
    if (amIUser1) {
      haveIBlocked = chat.hasUser1Blocked;
      hasOtherBlocked = chat.hasUser2Blocked;
    } else {
      haveIBlocked = chat.hasUser2Blocked;
      hasOtherBlocked = chat.hasUser1Blocked;
    }

    int badgeCount = 0;
    String lastMessage;
    bool hasLastMessage = false;

    final listOfMessages = Provider.of<Map<String, List<String>>>(context);
    print(listOfMessages);
    if (listOfMessages.containsKey(otherUid)) {
      badgeCount = listOfMessages[otherUid].length;
      lastMessage = listOfMessages[otherUid].last;
      hasLastMessage = true;
      if (listOfMessages[otherUid].last == "empty") {
        badgeCount = 0;
        hasLastMessage = false ;
      }
    } else {
      badgeCount = 0;
      hasLastMessage = false ;
    }

    return CustomCard(
      leading: ProfilePicture(
          imageFileName: otherImageFileName,
          imageVersionNumber: otherImageVersionNumber,
          radius: 30,
          heroTag: heroTag),
      middle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    otherUsername,
                    overflow: TextOverflow.ellipsis,
                    style: kUsernameTextStyle,
                  ),
                  SizedBox(width: 10),
                  Badge(count: badgeCount, badgeColor: Colors.red),
                ],
              ),
              Flexible(
                child: Text(
                  HelperFunctions.getTimestampAsString(
                      timestamp: chat.lastMessageTimestamp),
                  overflow: TextOverflow.ellipsis,
                  style: kChatTabTimestampTextStyle,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Text(
                  hasLastMessage ? lastMessage : chat.lastMessageText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: kChatLastMessageTextStyle,
                ),
              ),
              if (haveIBlocked || hasOtherBlocked)
                Expanded(
                  child: Text(
                    'blocked',
                    style: kSmallBlockedTextStyle,
                  ),
                )
            ],
          ),
        ],
      ),
      onPress: () {
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute<void>(
            builder: (context) {
              final firebaseMessaging =
                  Provider.of<FirebaseCloudMessaging>(context, listen: false);
              firebaseMessaging.clearNotificationMessagesOf(uid: otherUid);
             return ChatScreen(
                loggedInUid: loggedInUser.uid,
                otherUid: otherUid,
                otherUsername: otherUsername,
                otherImageFileName: otherImageFileName,
                otherImageVersionNumber: otherImageVersionNumber,
                heroTag: heroTag,
                chatPath: chat.chatpath,
              );
            },
          ),
        );
      },
    );
  }
}
