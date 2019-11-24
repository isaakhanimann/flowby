import 'package:flutter/material.dart';
import 'package:float/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final _fireStore = Firestore.instance;
FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  final DocumentSnapshot otherUser;
  ChatScreen({this.otherUser});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText;
  String chatPath;
  Stream<QuerySnapshot> messageStream;

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> getChatPath() async {
    try {
      String chatPath;
      QuerySnapshot snapshot1 = await _fireStore
          .collection('chats')
          .where('user1', isEqualTo: loggedInUser.email)
          .where('user2', isEqualTo: widget.otherUser.data['email'])
          .getDocuments();
      QuerySnapshot snapshot2 = await _fireStore
          .collection('chats')
          .where('user1', isEqualTo: widget.otherUser.data['email'])
          .where('user2', isEqualTo: loggedInUser.email)
          .getDocuments();
      print('If this gets printed up to here everything is fine');
      print('snapshot1 = ${snapshot1.documents}');
      print('snapshot2 = ${snapshot2.documents}');
      if (snapshot1.documents.isNotEmpty) {
        //loggedInUser is user1
        chatPath = snapshot1.documents[0].reference.path;
      } else if (snapshot2.documents.isNotEmpty) {
        //loggedInUser is user2
        chatPath = snapshot2.documents[0].reference.path;
      } else {
        //there is no chat yet
      }
      return chatPath;
    } catch (e) {
      print('Isaak could not get snapshot of chats');
    }
    return null;
  }

  void createChat() {
    _fireStore.collection('chats').add({
      'user1': loggedInUser.email,
      'user2': widget.otherUser.data['email'],
    });
    getChat();
  }

  void getChat() async {
    await getCurrentUser();
    String chatPath = await getChatPath();
    if (chatPath == null) {
      //create chat
      createChat();
    }
    print('chatPath = $chatPath');
    var messageStream = _fireStore
        .document(chatPath)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
    setState(() {
      this.chatPath = chatPath;
      this.messageStream = messageStream;
    });
  }

  @override
  void initState() {
    super.initState();
    getChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text(widget.otherUser.data['username'] ?? 'Default'),
        backgroundColor: kDarkGreenColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(
              messagesStream: messageStream,
            ),
            Container(
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
                  FlatButton(
                    onPressed: () async {
                      //Implement send functionality.
                      messageTextController.clear();
                      _fireStore.document(chatPath).collection('messages').add(
                        {
                          'text': messageText,
                          'sender': loggedInUser.email,
                          'timestamp': FieldValue.serverTimestamp(),
                        },
                      );
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
    print('messagesStream = $messagesStream');
    return StreamBuilder<QuerySnapshot>(
      stream: messagesStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Expanded(
            child: SpinKitPumpingHeart(
              color: kDarkGreenColor,
              size: 100,
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];
          final messageTimestamp = message.data['timestamp'].toDate();
          final String timestamp =
              '${messageTimestamp.hour.toString()}:${messageTimestamp.minute.toString()} ${messageTimestamp.day.toString()}. ${getMonthString(messageTimestamp.month)}.';

          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            text: messageText,
            timestamp: timestamp,
            isMe: currentUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
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
