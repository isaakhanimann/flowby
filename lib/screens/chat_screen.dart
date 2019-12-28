import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/message.dart';
import 'package:float/models/user.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  final User otherUser;

  ChatScreen({this.otherUser});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    var loggedInUser = Provider.of<FirebaseUser>(context);

    return FutureBuilder(
      future: FirebaseConnection.getChatPath(
          user: loggedInUser.email, otherUser: widget.otherUser.email),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CupertinoActivityIndicator();
        }
        if (snapshot.hasError) {
          return Container(
            color: Colors.red,
            child: Text('Something went wrong'),
          );
        }
        String chatPath = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            title: Text(widget.otherUser.username ?? 'Default'),
            backgroundColor: kDarkGreenColor,
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                MessagesStream(
                  messagesStream:
                      FirebaseConnection.getMessageStream(chatPath: chatPath),
                ),
                MessageSendingSection(chatPath: chatPath),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MessagesStream extends StatelessWidget {
  String getMonthString(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Okt';
      case 11:
        return 'Nov';
      case 12:
        return 'Dez';
      default:
        return 'Error';
    }
  }

  final messagesStream;

  MessagesStream({this.messagesStream});

  @override
  Widget build(BuildContext context) {
    var loggedInUser = Provider.of<FirebaseUser>(context);

    return StreamBuilder<List<Message>>(
      stream: messagesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return Expanded(
            child: CupertinoActivityIndicator(),
          );
        }

        final List<Message> messages = snapshot.data;

        return Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              Message message = messages[index];
              var messageTimestamp = message.timestamp;
              return MessageBubble(
                text: message.text,
                timestamp:
                    '${messageTimestamp.hour.toString()}:${messageTimestamp.minute.toString()} ${messageTimestamp.day.toString()}. ${getMonthString(messageTimestamp.month)}.',
                isMe: loggedInUser.email == message.sender,
              );
            },
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
          ),
        );
      },
    );
  }
}

class MessageSendingSection extends StatefulWidget {
  final String chatPath;

  MessageSendingSection({@required this.chatPath});

  @override
  _MessageSendingSectionState createState() => _MessageSendingSectionState();
}

class _MessageSendingSectionState extends State<MessageSendingSection> {
  final messageTextController = TextEditingController();
  String messageText;

  @override
  Widget build(BuildContext context) {
    var loggedInUser = Provider.of<FirebaseUser>(context);

    return Container(
      decoration: kMessageContainerDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: messageTextController,
              onChanged: (value) {
                //Do something with the user input.
                messageText = value;
              },
              decoration: kMessageTextFieldDecoration,
            ),
          ),
          SendButton(
            onPress: () async {
              // prevent to send the previously typed message with an empty text field
              if (messageText != '') {
                //Implement send functionality.
                messageTextController.clear();
                Message message = Message(
                    sender: loggedInUser.email,
                    text: messageText,
                    timestamp: FieldValue.serverTimestamp());
                FirebaseConnection.uploadMessage(
                    chatPath: widget.chatPath, message: message);
                messageText = ''; // Reset locally the sent message
              }
            },
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.timestamp, this.text, this.isMe});

  final String timestamp;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            timestamp,
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
            elevation: 5.0,
            color: isMe ? kDarkGreenColor : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: isMe ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final Function onPress;

  SendButton({@required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Material(
        color: kDarkGreenColor,
        borderRadius: BorderRadius.circular(30.0),
        child: IconButton(
          onPressed: onPress,
          icon: Icon(
            Icons.send,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
