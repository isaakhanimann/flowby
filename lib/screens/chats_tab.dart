import 'package:Flowby/constants.dart';
import 'package:Flowby/models/chat.dart';
import 'package:Flowby/models/helper_functions.dart';
import 'package:Flowby/screens/chat_screen.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/widgets/sign_in_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class ChatsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    //listening to loggedInUser (so it rebuilds) is not necessary as the navigationscreen provides it and always has the up to date value because it is rebuilt whenever we navigate to it
    final loggedInUser = Provider.of<FirebaseUser>(context, listen: false);
    if (loggedInUser == null) {
      return Center(child: SignInButton());
    }

    return StreamBuilder(
        stream:
            cloudFirestoreService.getChatsStream(loggedInUid: loggedInUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
              ),
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
                backgroundColor: CupertinoColors.white,
                border: null,
                largeTitle: Text(
                  'Chats',
                  style: kTabsLargeTitleTextStyle,
                ),
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

    return Card(
      elevation: 0,
      color: kCardBackgroundColor,
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
          leading: CachedNetworkImage(
            imageUrl:
                "https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F$otherImageFileName?alt=media",
            imageBuilder: (context, imageProvider) {
              return Hero(
                transitionOnUserGestures: true,
                tag: heroTag,
                child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: imageProvider),
              );
            },
            placeholder: (context, url) => CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
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
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                HelperFunctions.getDotDotDotString(
                    maybeLongString: chat.lastMessageText),
                style: TextStyle(color: Colors.black38, fontSize: 15),
              ),
              if (haveIBlocked || hasOtherBlocked)
                Icon(
                  Feather.x,
                  color: Colors.red,
                ),
            ],
          ),
          trailing: Icon(Feather.chevron_right),
        ),
      ),
    );
  }
}
