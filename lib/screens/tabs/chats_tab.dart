import 'package:Flowby/app_localizations.dart';
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
  Stream<List<Chat>> chatStream;

  @override
  void initState() {
    super.initState();
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    final loggedInUser = Provider.of<User>(context, listen: false);
    chatStream =
        cloudFirestoreService.getChatsStream(loggedInUid: loggedInUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TabHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
            child: Text(
              AppLocalizations.of(context).translate('chats'),
              style: kTabTitleTextStyle,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
              child: StreamBuilder(
                  stream: chatStream,
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
                            AppLocalizations.of(context)
                                .translate('no_open_chats'),
                            style: kCardSubtitleTextStyle),
                      );
                    }
                    return ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          return ChatItem(
                            chat: chats[index],
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
    final firebaseMessaging =
        Provider.of<FirebaseCloudMessaging>(context, listen: false);

    bool amIUser1 = chat.user1.uid == loggedInUser.uid;

    User otherUser = amIUser1 ? chat.user2 : chat.user1;

    final heroTag = otherUser.uid + 'chats';

    bool haveIBlocked;
    bool hasOtherBlocked;
    int numberOfUnreadMessages;
    if (amIUser1) {
      haveIBlocked = chat.hasUser1Blocked;
      hasOtherBlocked = chat.hasUser2Blocked;
      numberOfUnreadMessages = chat.numberOfUnreadMessagesUser1;
    } else {
      haveIBlocked = chat.hasUser2Blocked;
      hasOtherBlocked = chat.hasUser1Blocked;
      numberOfUnreadMessages = chat.numberOfUnreadMessagesUser2;
    }

    return CustomCard(
      leading: ProfilePicture(
          imageUrl: otherUser.imageUrl, radius: 30, heroTag: heroTag),
      middle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                otherUser.username,
                overflow: TextOverflow.ellipsis,
                style: kUsernameTextStyle,
              ),
              SizedBox(width: 10),
              if (numberOfUnreadMessages != null)
                Badge(count: numberOfUnreadMessages, badgeColor: Colors.red),
              Flexible(
                child: Text(
                  HelperFunctions.getTimestampAsString(
                      context: context, timestamp: chat.lastMessageTimestamp),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
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
                flex: 1,
                child: Text(
                  chat.lastMessageText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: kChatLastMessageTextStyle,
                ),
              ),
              if (haveIBlocked || hasOtherBlocked)
                Text(
                  AppLocalizations.of(context).translate('blocked'),
                  style: kSmallBlockedTextStyle,
                )
            ],
          ),
        ],
      ),
      onPress: () async {
        await Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute<void>(
            builder: (context) {
              // removes the current notifications of the opened chat
              firebaseMessaging.cancel(otherUser.uid.hashCode);
              return ChatScreen(
                loggedInUser: loggedInUser,
                otherUser: otherUser,
                heroTag: heroTag,
                chatPath: chat.chatpath,
              );
            },
          ),
        );
        _updateUnreadMessages(
            context: context,
            amIUser1: amIUser1,
            loggedInUid: loggedInUser.uid);
      },
    );
  }

  _updateUnreadMessages(
      {BuildContext context, bool amIUser1, String loggedInUid}) {
    // subtract the number of unread messages from the global total
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    cloudFirestoreService.updateUserTotalUnreadMessages(
        chatPath: chat.chatpath, isUser1: amIUser1, uid: loggedInUid);
    // set to 0 the number of unread messages of the chat when user leaves the chat
    cloudFirestoreService.resetUnreadMessagesInChat(
        chatPath: chat.chatpath, isUser1: amIUser1);
  }
}
