import 'package:Flowby/app_localizations.dart';
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
import 'package:Flowby/models/user.dart';

class ChatScreen extends StatefulWidget {
  final User loggedInUser;
  final User otherUser;
  final String heroTag;
  final String chatId;

  ChatScreen(
      {@required
          this.loggedInUser, //is needed because this screen can't access it with provider
      @required
          this.otherUser, //is needed to display the other users image and name
      @required
          this.heroTag, //is needed for the hero animation
      @required
          this.chatId}); //is needed to get the chat stream

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<ChatJustWithFieldsNeededForChatScreen> chatStream;

  @override
  void initState() {
    super.initState();
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    chatStream = cloudFirestoreService
        .getChatStreamJustWithFieldsNeededForChatScreen(chatId: widget.chatId);
  }

  @override
  Widget build(BuildContext context) {
    return Provider<GlobalChatScreenInfo>(
      create: (_) => GlobalChatScreenInfo(
          loggedInUser: widget.loggedInUser,
          otherUser: widget.otherUser,
          chatId: widget.chatId,
          heroTag: widget.heroTag),
      child: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.white,
        child: SafeArea(
          child: StreamBuilder(
            stream: chatStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.none) {
                return ChatIsLoading();
              }
              print('whole chat screen rebuilt');

              final ChatJustWithFieldsNeededForChatScreen chat = snapshot.data;
              print('chat = $chat');

              return ChatHasLoaded(chat: chat);
            },
          ),
        ),
      ),
    );
  }
}

class ChatHasLoaded extends StatelessWidget {
  const ChatHasLoaded({
    Key key,
    @required this.chat,
  }) : super(key: key);

  final ChatJustWithFieldsNeededForChatScreen chat;

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
                  cloudFirestoreService.getMessageStream(chatId: chat.chatId),
            ),
          ),
          MessageSendingSection(chat: chat),
        ],
      ),
      ChatHeader(
        chat: chat,
      ),
    ]);
  }
}

class ChatIsLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    GlobalChatScreenInfo screenInfo =
        Provider.of<GlobalChatScreenInfo>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ChatHeader(),
        Expanded(
          child: MessagesStream(
            messagesStream: cloudFirestoreService.getMessageStream(
                chatId: screenInfo.chatId),
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
      child: CenteredLoadingIndicator(),
    );
  }
}

class ChatHeader extends StatelessWidget {
  const ChatHeader({Key key, this.chat}) : super(key: key);

  final ChatJustWithFieldsNeededForChatScreen chat;

  @override
  Widget build(BuildContext context) {
    GlobalChatScreenInfo screenInfo =
        Provider.of<GlobalChatScreenInfo>(context, listen: false);
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    bool amIUser1;
    bool haveIBlocked;
    if (chat != null) {
      amIUser1 = (chat.user1.uid == screenInfo.loggedInUser.uid);
      if (amIUser1) {
        haveIBlocked = chat.hasUser1Blocked;
      } else {
        haveIBlocked = chat.hasUser2Blocked;
      }
    }
    return Container(
      color: Color(0xFFFFFFFF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
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
              Navigator.of(context, rootNavigator: true).push(
                ScaleRoute(
                  page: ShowProfilePictureScreen(
                    imageUrl: screenInfo.otherUser.imageUrl,
                    otherUsername: screenInfo.otherUser.username,
                    heroTag: screenInfo.heroTag,
                  ),
                ),
              );
            },
            child: CachedNetworkImage(
              imageUrl: screenInfo.otherUser.imageUrl,
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
              placeholder: (context, url) => CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(
              screenInfo.otherUser.username,
              overflow: TextOverflow.ellipsis,
              style: kChatScreenHeaderTextStyle,
            ),
          ),
          Expanded(
            child: Container(
              height: 10,
            ),
          ),
          if (chat == null)
            CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
            ),
          if (chat != null)
            CupertinoButton(
              child: haveIBlocked
                  ? Text(
                      AppLocalizations.of(context).translate('unblock'),
                    )
                  : Text(
                      AppLocalizations.of(context).translate('block'),
                    ),
              onPressed: () {
                if (!haveIBlocked) {
                  HelperFunctions.showCustomDialog(
                    context: context,
                    dialog: TwoOptionsDialog(
                      title: AppLocalizations.of(context)
                          .translate('are_you_sure'),
                      text: AppLocalizations.of(context)
                          .translate('blocked_contacts_cant_send'),
                      rightActionText:
                          AppLocalizations.of(context).translate('block'),
                      rightActionColor: Colors.red,
                      rightAction: () {
                        if (amIUser1) {
                          cloudFirestoreService.uploadChatBlocked(
                              chatId: chat.chatId,
                              hasUser1Blocked: !haveIBlocked);
                        } else {
                          cloudFirestoreService.uploadChatBlocked(
                              chatId: chat.chatId,
                              hasUser2Blocked: !haveIBlocked);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  );
                } else {
                  if (amIUser1) {
                    cloudFirestoreService.uploadChatBlocked(
                        chatId: chat.chatId, hasUser1Blocked: !haveIBlocked);
                  } else {
                    cloudFirestoreService.uploadChatBlocked(
                        chatId: chat.chatId, hasUser2Blocked: !haveIBlocked);
                  }
                }
              },
            )
        ],
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
        Provider.of<GlobalChatScreenInfo>(context, listen: false);
    return StreamBuilder<List<Message>>(
      stream: messagesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return CenteredLoadingIndicator();
        }

        final List<Message> messages = snapshot.data;

        if (messages == null) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Text(
                AppLocalizations.of(context).translate('no_messages_yet'),
              ),
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
                  context: context, timestamp: messageTimestamp),
              isMe: screenInfo.loggedInUser.uid == message.senderUid,
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
  final ChatJustWithFieldsNeededForChatScreen chat;

  MessageSendingSection({@required this.chat});

  @override
  _MessageSendingSectionState createState() => _MessageSendingSectionState();
}

class _MessageSendingSectionState extends State<MessageSendingSection> {
  final messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    GlobalChatScreenInfo screenInfo =
        Provider.of<GlobalChatScreenInfo>(context, listen: false);
    bool amIUser1 = widget.chat.user1.uid == screenInfo.loggedInUser.uid;
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
              AppLocalizations.of(context)
                  .translate('you_have_blocked_this_person'),
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
            (amIUser1
                    ? widget.chat.user2.username
                    : widget.chat.user1.username) +
                ' ' +
                AppLocalizations.of(context).translate('has_blocked_you'),
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
              autocorrect: false,
              maxLength: 200,
              expands: true,
              maxLines: null,
              minLines: null,
              placeholder:
                  AppLocalizations.of(context).translate('type_message'),
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
              GlobalChatScreenInfo screenInfo =
                  Provider.of<GlobalChatScreenInfo>(context, listen: false);
              Message message = Message(
                  senderUid: screenInfo.loggedInUser.uid,
                  text: messageTextController.text,
                  timestamp: FieldValue.serverTimestamp());
              cloudFirestoreService.uploadMessage(
                  chatId: widget.chat.chatId, message: message);
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
  final User loggedInUser;
  final User otherUser;
  final String chatId;
  final String heroTag;

  GlobalChatScreenInfo(
      {@required this.loggedInUser,
      @required this.otherUser,
      @required this.chatId,
      @required this.heroTag});
}
