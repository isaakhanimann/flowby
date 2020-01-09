import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:float/constants.dart';
import 'package:float/models/message.dart';
import 'package:float/models/timestamp_to_string.dart';
import 'package:float/services/firebase_cloud_firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  static const String id = 'chat_screen';
  final String loggedInUid;
  final String otherUid;
  final String otherUsername;
  final String otherImageFileName;
  final String heroTag;

  final String chatPath;
  //either the chatPath is supplied and we can get the messageStream directly
  //or if he isn't we can user the other user to figure out the chatpath ourselves
  ChatScreen(
      {@required this.loggedInUid,
      @required this.otherUid,
      @required this.otherUsername,
      @required this.heroTag,
      @required this.otherImageFileName,
      this.chatPath});

  @override
  Widget build(BuildContext context) {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    if (chatPath != null) {
      return Provider<String>.value(
        value: loggedInUid,
        child: ChatScreenWithPath(
            otherUsername: otherUsername,
            otherImageFileName: otherImageFileName,
            heroTag: heroTag,
            chatPath: chatPath),
      );
    }

    return FutureBuilder(
      future: cloudFirestoreService.getChatPath(
          loggedInUid: loggedInUid,
          otherUid: otherUid,
          otherUsername: otherUsername,
          otherUserImageFileName: otherImageFileName),
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
        String foundChatPath = snapshot.data;

        return Provider<String>.value(
          value: loggedInUid,
          child: ChatScreenWithPath(
              otherUsername: otherUsername,
              otherImageFileName: otherImageFileName,
              heroTag: heroTag,
              chatPath: foundChatPath),
        );
      },
    );
  }
}

class ChatScreenWithPath extends StatelessWidget {
  const ChatScreenWithPath({
    Key key,
    @required this.otherUsername,
    @required this.otherImageFileName,
    @required this.heroTag,
    @required this.chatPath,
  }) : super(key: key);

  final String otherUsername;
  final String chatPath;
  final String otherImageFileName;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Row(
          children: <Widget>[
            Hero(
              tag: heroTag,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F$otherImageFileName?alt=media'),
              ),
            ),
            SizedBox(width: 30),
            Text(otherUsername ?? 'Default'),
          ],
        ),
        backgroundColor: kDarkGreenColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(
              messagesStream:
                  cloudFirestoreService.getMessageStream(chatPath: chatPath),
            ),
            MessageSendingSection(chatPath: chatPath),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  final messagesStream;

  MessagesStream({this.messagesStream});

  @override
  Widget build(BuildContext context) {
    String loggedInUid = Provider.of<String>(context);
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

        if (messages == null) {
          return Container(color: Colors.white);
        }
        return Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              Message message = messages[index];
              var messageTimestamp = message.timestamp;
              return MessageBubble(
                text: message.text,
                timestamp:
                    TimestampToString.getString(timestamp: messageTimestamp),
                isMe: loggedInUid == message.senderUid,
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
    String loggedInUid = Provider.of<String>(context);
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
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
                    senderUid: loggedInUid,
                    text: messageText,
                    timestamp: FieldValue.serverTimestamp());
                cloudFirestoreService.uploadMessage(
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
