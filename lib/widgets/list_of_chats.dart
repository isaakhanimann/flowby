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
                    otherUserUid: (chat.user1 == loggedInUser.email)
                        ? chat.user2
                        : chat.user1,
                    otherUsername: (chat.user1 == loggedInUser.email)
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
                fileName: (chat.user1 == loggedInUser.email)
                    ? chat.user2
                    : chat.user1),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(snapshot.data),
                );
              }
              return CircleAvatar(
                backgroundColor: Colors.grey,
              );
            },
          ),
          title: Text(
            (chat.user1 == loggedInUser.email)
                ? chat.username2
                : chat.username1,
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
