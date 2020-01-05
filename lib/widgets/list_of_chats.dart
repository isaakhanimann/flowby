import 'package:float/constants.dart';
import 'package:float/models/chat.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/chat_screen.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfChats extends StatelessWidget {
  const ListOfChats({
    Key key,
    @required this.chats,
  }) : super(key: key);

  final List<Chat> chats;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemExtent: 90,
      itemBuilder: (context, index) {
        return ChatItem(
          chat: chats[index],
        );
      },
      itemCount: chats.length,
    );
  }
}

class ChatItem extends StatelessWidget {
  final Chat chat;

  ChatItem({@required this.chat});

  @override
  Widget build(BuildContext context) {
    var loggedInUser = Provider.of<User>(context);

    return Card(
      elevation: 0,
      color: kLightGrey2,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Center(
        child: ListTile(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<void>(
                builder: (context) {
                  return ChatScreen(
                    otherUserUid:
                        (chat.uid1 == loggedInUser.uid) ? chat.uid2 : chat.uid1,
                    otherUsername: (chat.uid1 == loggedInUser.uid)
                        ? chat.username2
                        : chat.username1,
                    chatPath: chat.chatpath,
                  );
                },
              ),
            );
          },
          leading: FutureBuilder(
            future: FirebaseConnection.getImageUrl(
                fileName:
                    (chat.uid1 == loggedInUser.uid) ? chat.uid2 : chat.uid1),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                String imageUrl = snapshot.data;
                if (imageUrl != null) {
                  return CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(imageUrl),
                  );
                } else {
                  return CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        AssetImage('images/default-profile-pic.jpg'),
                  );
                }
              }
              return CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
              );
            },
          ),
          title: Text(
            (chat.uid1 == loggedInUser.uid) ? chat.username2 : chat.username1,
            style: kUsernameTextStyle,
          ),
          subtitle: Text(
            chat.lastMessageText,
            style: kUsernameTextStyle,
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ),
    );
  }
}
