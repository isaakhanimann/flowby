import 'package:Flowby/constants.dart';
import 'package:Flowby/models/helper_functions.dart';
import 'package:Flowby/models/message.dart';
import 'package:Flowby/screens/show_profile_picture_screen.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
          return CupertinoPageScaffold(
              backgroundColor: CupertinoColors.white,
              child: CupertinoActivityIndicator());
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

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: SafeArea(
        child: Stack(children: [
          Column(
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
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Feather.chevron_left,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => ShowProfilePictureScreen(
                                    profilePictureUrl:
                                        'https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F$otherImageFileName?alt=media',
                                    otherUsername: otherUsername,
                                    heroTag: heroTag,
                                  )));
                    },
                    child: Row(
                      children: <Widget>[
                        CachedNetworkImage(
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
                          placeholder: (context, url) =>
                              CupertinoActivityIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          otherUsername,
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'MuliRegular'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
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
                timestamp: HelperFunctions.getTimestampAsString(
                    timestamp: messageTimestamp),
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

  @override
  Widget build(BuildContext context) {
    String loggedInUid = Provider.of<String>(context);
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: CupertinoTextField(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    border: Border.all(color: kLightGrey),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                controller: messageTextController,
              ),
            ),
          ),
          SendButton(
            onPress: () async {
              // prevent to send the previously typed message with an empty text field
              if (messageTextController.text != '') {
                //Implement send functionality.
                Message message = Message(
                    senderUid: loggedInUid,
                    text: messageTextController.text,
                    timestamp: FieldValue.serverTimestamp());
                cloudFirestoreService.uploadMessage(
                    chatPath: widget.chatPath, message: message);
                messageTextController.clear(); // Reset locally the sent message
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
      padding: EdgeInsets.symmetric(horizontal: 10.0),
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
            color: isMe ? ffMiddleBlue : Colors.white,
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
    return CupertinoButton(
      onPressed: onPress,
      child: Container(
        padding: EdgeInsets.all(9),
        decoration: ShapeDecoration(
            color: kDefaultProfilePicColor, shape: CircleBorder()),
        child: Icon(
          Feather.send,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}
