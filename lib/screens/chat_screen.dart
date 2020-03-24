import 'package:Flowby/constants.dart';
import 'package:Flowby/models/helper_functions.dart';
import 'package:Flowby/models/message.dart';
import 'package:Flowby/screens/show_profile_picture_screen.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/widgets/copyable_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/models/chat_without_last_message.dart';
import 'package:Flowby/widgets/route_transitions/scale_route.dart';
import 'package:Flowby/widgets/centered_loading_indicator.dart';
import 'package:Flowby/widgets/two_options_dialog.dart';

class ChatScreen extends StatelessWidget {
  static const String id = 'chat_screen';
  final String loggedInUid;
  final String otherUid;
  final String otherUsername;
  final String otherImageFileName;
  final int otherImageVersionNumber;
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
      @required this.otherImageVersionNumber,
      this.chatPath});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: SafeArea(
        child: Provider<GlobalChatScreenInfo>(
          create: (_) => GlobalChatScreenInfo(
              loggedInUid: loggedInUid,
              otherUid: otherUid,
              otherUsername: otherUsername,
              otherImageFileName: otherImageFileName,
              otherImageVersionNumber: otherImageVersionNumber,
              heroTag: heroTag),
          child: (chatPath != null)
              ? ChatScreenWithPath(chatPath: chatPath)
              : ChatScreenThatHasToGetPath(),
        ),
      ),
    );
  }
}

class ChatScreenThatHasToGetPath extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GlobalChatScreenInfo screenInfo =
        Provider.of<GlobalChatScreenInfo>(context);
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    return FutureBuilder(
      future: cloudFirestoreService.getChatPath(
          loggedInUid: screenInfo.loggedInUid,
          otherUid: screenInfo.otherUid,
          otherUsername: screenInfo.otherUsername,
          otherUserImageFileName: screenInfo.otherImageFileName),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CenteredLoadingIndicator();
        }
        if (snapshot.hasError) {
          return Container(
            color: Colors.red,
            child: const Text('Something went wrong'),
          );
        }
        String foundChatPath = snapshot.data;

        return ChatScreenWithPath(chatPath: foundChatPath);
      },
    );
  }
}

class ChatScreenWithPath extends StatelessWidget {
  const ChatScreenWithPath({
    Key key,
    @required this.chatPath,
  }) : super(key: key);

  final String chatPath;

  @override
  Widget build(BuildContext context) {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    return StreamBuilder(
      stream: cloudFirestoreService.getChatStreamWithoutLastMessageField(
          chatPath: chatPath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return ChatIsLoading(chatPath: chatPath);
        }

        final ChatWithoutLastMessage chat = snapshot.data;

        return ChatHasLoaded(chat: chat, chatPath: chatPath);
      },
    );
  }
}

class ChatHasLoaded extends StatelessWidget {
  const ChatHasLoaded({
    Key key,
    @required this.chatPath,
    @required this.chat,
  }) : super(key: key);

  final String chatPath;
  final ChatWithoutLastMessage chat;

  @override
  Widget build(BuildContext context) {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    return Stack(children: [
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 60),
          Expanded(
            child: MessagesStream(
              messagesStream:
                  cloudFirestoreService.getMessageStream(chatPath: chatPath),
            ),
          ),
          MessageSendingSection(chat: chat),
        ],
      ),
      ChatHeader(chat: chat),
    ]);
  }
}

class ChatIsLoading extends StatelessWidget {
  const ChatIsLoading({
    Key key,
    @required this.chatPath,
  }) : super(key: key);

  final String chatPath;

  @override
  Widget build(BuildContext context) {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ChatHeader(),
        Expanded(
          child: MessagesStream(
            messagesStream:
                cloudFirestoreService.getMessageStream(chatPath: chatPath),
          ),
        ),
        MessageSendingSectionLoading(),
      ],
    );
  }
}

class MessageSendingSectionLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
      ),
    );
  }
}

class ChatHeader extends StatelessWidget {
  const ChatHeader({Key key, this.chat}) : super(key: key);

  final ChatWithoutLastMessage chat;

  @override
  Widget build(BuildContext context) {
    GlobalChatScreenInfo screenInfo =
        Provider.of<GlobalChatScreenInfo>(context);
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    bool amIUser1;
    bool haveIBlocked;
    if (chat != null) {
      amIUser1 = (chat.uid1 == screenInfo.loggedInUid);
      if (amIUser1) {
        haveIBlocked = chat.hasUser1Blocked;
      } else {
        haveIBlocked = chat.hasUser2Blocked;
      }
    }
    return Container(
      color: Color(0xFFFFFFFF),
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
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
                    size: 30,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(ScaleRoute(
                        page: ShowProfilePictureScreen(
                      imageFileName: screenInfo.otherImageFileName,
                      imageVersionNumber: screenInfo.otherImageVersionNumber,
                      otherUsername: screenInfo.otherUsername,
                      heroTag: screenInfo.heroTag,
                    )));
                  },
                  child: Row(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl:
                            "https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F${screenInfo.otherImageFileName}?alt=media&version=${screenInfo.otherImageVersionNumber}",
                        imageBuilder: (context, imageProvider) {
                          return Hero(
                            transitionOnUserGestures: true,
                            tag: screenInfo.heroTag,
                            child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey,
                                backgroundImage: imageProvider),
                          );
                        },
                        placeholder: (context, url) =>
                            CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              kDefaultProfilePicColor),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        screenInfo.otherUsername,
                        overflow: TextOverflow.ellipsis,
                        style: kChatScreenHeaderTextStyle,
                      )
                    ],
                  ),
                ),
              ],
            ),
            if (chat == null)
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
              ),
            if (chat != null)
              Flexible(
                child: CupertinoButton(
                  child: haveIBlocked ? Text('Unblock') : Text('Block'),
                  onPressed: () {
                    if (!haveIBlocked) {
                      HelperFunctions.showCustomDialog(
                        context: context,
                        dialog: TwoOptionsDialog(
                          title: 'Block ${screenInfo.otherUsername}?',
                          text:
                              'Blocked contacts will no longer be able to send you messages',
                          rightActionText: 'Block',
                          rightActionColor: Colors.red,
                          rightAction: () {
                            if (amIUser1) {
                              cloudFirestoreService.uploadChatBlocked(
                                  chatpath: chat.chatpath,
                                  hasUser1Blocked: !haveIBlocked);
                            } else {
                              cloudFirestoreService.uploadChatBlocked(
                                  chatpath: chat.chatpath,
                                  hasUser2Blocked: !haveIBlocked);
                            }
                            Navigator.pop(context);
                          },
                        ),
                      );
                    } else {
                      if (amIUser1) {
                        cloudFirestoreService.uploadChatBlocked(
                            chatpath: chat.chatpath,
                            hasUser1Blocked: !haveIBlocked);
                      } else {
                        cloudFirestoreService.uploadChatBlocked(
                            chatpath: chat.chatpath,
                            hasUser2Blocked: !haveIBlocked);
                      }
                    }
                  },
                ),
              )
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
    GlobalChatScreenInfo screenInfo =
        Provider.of<GlobalChatScreenInfo>(context);
    return StreamBuilder<List<Message>>(
      stream: messagesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
          );
        }

        final List<Message> messages = snapshot.data;

        if (messages == null) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Text('No messages yet'),
            ),
          );
        }
        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            Message message = messages[index];
            var messageTimestamp = message.timestamp;
            return MessageRow(
              text: message.text,
              timestamp: HelperFunctions.getTimestampAsString(
                  timestamp: messageTimestamp),
              isMe: screenInfo.loggedInUid == message.senderUid,
            );
          },
          reverse: true,
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
        );
      },
    );
  }
}

class MessageSendingSection extends StatefulWidget {
  final ChatWithoutLastMessage chat;

  MessageSendingSection({@required this.chat});

  @override
  _MessageSendingSectionState createState() => _MessageSendingSectionState();
}

class _MessageSendingSectionState extends State<MessageSendingSection> {
  final messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GlobalChatScreenInfo screenInfo =
        Provider.of<GlobalChatScreenInfo>(context);
    bool amIUser1 = widget.chat.uid1 == screenInfo.loggedInUid;
    bool haveIBlocked;
    bool hasOtherBlocked;
    if (amIUser1) {
      haveIBlocked = widget.chat.hasUser1Blocked;
      hasOtherBlocked = widget.chat.hasUser2Blocked;
    } else {
      haveIBlocked = widget.chat.hasUser2Blocked;
      hasOtherBlocked = widget.chat.hasUser1Blocked;
    }
    if (haveIBlocked) {
      return Container(
        height: 80,
        child: Center(
          child: Text(
              'You have blocked ${amIUser1 ? widget.chat.username2 : widget.chat.username1}',
              overflow: TextOverflow.ellipsis,
              style: kBlockedTextStyle),
        ),
      );
    }
    if (hasOtherBlocked) {
      return Container(
        height: 80,
        child: Center(
          child: Text(
            '${amIUser1 ? widget.chat.username2 : widget.chat.username1} has blocked you',
            style: kBlockedTextStyle,
          ),
        ),
      );
    }
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: CupertinoTextField(
              textCapitalization: TextCapitalization.sentences,
              maxLength: 200,
              expands: true,
              maxLines: null,
              minLines: null,
              placeholder: 'Type a message',
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              decoration: BoxDecoration(
                  color: kCardBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
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
                  senderUid: screenInfo.loggedInUid,
                  text: messageTextController.text,
                  timestamp: FieldValue.serverTimestamp());
              cloudFirestoreService.uploadMessage(
                  chatPath: widget.chat.chatpath, message: message);
              messageTextController.clear(); // Reset locally the sent message
            }
          },
        ),
      ],
    );
  }
}

class MessageRow extends StatelessWidget {
  MessageRow({this.timestamp, this.text, this.isMe});

  final String timestamp;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
      child: Column(
        // a column with just one child because I haven't figure out out else to size the bubble to fit its contents instead of filling it
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          MessageBubble(isMe: isMe, text: text, timestamp: timestamp),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key key,
    @required this.isMe,
    @required this.text,
    @required this.timestamp,
  }) : super(key: key);

  final bool isMe;
  final String text;
  final String timestamp;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: isMe
          ? BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))
          : BorderRadius.only(
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
      elevation: 0.0,
      color: isMe ? kMessageBubbleColor : kCardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: <Widget>[
            CopyableText(
              text,
              style: TextStyle(
                fontSize: 15.0,
                color: isMe ? Colors.white : kKeywordHeaderColor,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              timestamp,
              style: TextStyle(
                  fontSize: 10.0,
                  color: isMe ? Colors.white70 : Colors.black54),
            ),
          ],
        ),
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
          color: kBlueButtonColor,
          size: 22,
        ),
      ),
    );
  }
}

class GlobalChatScreenInfo {
  final String loggedInUid;
  final String otherUid;
  final String otherUsername;
  final String otherImageFileName;
  final int otherImageVersionNumber;
  final String heroTag;

  GlobalChatScreenInfo(
      {@required this.loggedInUid,
      @required this.otherUid,
      @required this.otherUsername,
      @required this.otherImageFileName,
      @required this.otherImageVersionNumber,
      @required this.heroTag});
}
