import 'package:float/constants.dart';
import 'package:float/models/chat.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/chat_screen.dart';
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
    if (chats.isEmpty) {
      // Scaffold damit text nicht gelb unterstrichen ist
      return Scaffold(
        body: Center(
          child: Text('You have no open chats', style: kSkillTextStyle),
        ),
      );
    }
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
    bool user1IsLoggedInUser = (chat.uid1 == loggedInUser.uid);
    String otherUid = user1IsLoggedInUser ? chat.uid2 : chat.uid1;
    String otherUsername =
        user1IsLoggedInUser ? chat.username2 : chat.username1;
    String otherImageFileName =
        user1IsLoggedInUser ? chat.user2ImageFileName : chat.user1ImageFileName;

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
                    otherUid: otherUid,
                    otherUsername: otherUsername,
                    otherImageFileName: otherImageFileName,
                    chatPath: chat.chatpath,
                  );
                },
              ),
            );
          },
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(
                'https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F$otherImageFileName?alt=media'),
          ),
          title: Text(
            otherUsername,
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
