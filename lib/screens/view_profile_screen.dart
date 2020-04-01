import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/chat_screen.dart';
import 'package:Flowby/screens/choose_signin_screen.dart';
import 'package:Flowby/widgets/centered_loading_indicator.dart';
import 'package:Flowby/widgets/listview_of_user_infos.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/models/chat.dart';

class ViewProfileScreen extends StatefulWidget {
  static const String id = 'view_profile_screen';
  final User user;
  final String heroTag;
  final User loggedInUser;
  final bool showSkills;

  ViewProfileScreen(
      {@required this.user,
      @required this.heroTag,
      @required this.loggedInUser,
      this.showSkills = true});

  @override
  _ViewProfileScreenState createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  bool _showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      progressIndicator: CenteredLoadingIndicator(),
      child: CupertinoPageScaffold(
        child: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              ListViewOfUserInfos(user: widget.user, heroTag: widget.heroTag),
              if (!(widget.loggedInUser?.uid == widget.user.uid))
                Positioned(
                  bottom: 20,
                  child: RoundedButton(
                    text: widget.loggedInUser == null
                        ? AppLocalizations.of(context)
                            .translate('sign_in_to_chat')
                        : AppLocalizations.of(context).translate('chat'),
                    color: kDefaultProfilePicColor,
                    textColor: kBlueButtonColor,
                    onPressed: () {
                      if (widget.loggedInUser == null) {
                        Navigator.of(context, rootNavigator: true)
                            .pushAndRemoveUntil(
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  ChooseSigninScreen()),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        _getChatAndNavigateToChatScreen(context);
                      }
                    },
                  ),
                ),
              Positioned(
                top: 5,
                left: 6,
                child: CupertinoButton(
                  child: Icon(
                    Feather.chevron_left,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getChatAndNavigateToChatScreen(BuildContext context) async {
    setState(() {
      _showSpinner = true;
    });
    //get the chatPath
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    Chat chat = await cloudFirestoreService.getChat(
        user1: widget.loggedInUser, user2: widget.user);

    setState(() {
      _showSpinner = false;
    });
    await Navigator.of(context).push(
      CupertinoPageRoute<void>(
        builder: (context) {
          return ChatScreen(
            chatId: chat.chatId,
            heroTag: widget.heroTag,
          );
        },
      ),
    );

    _updateUnreadMessages(
        context: context,
        chatId: chat.chatId,
        amIUser1: chat.user1.uid == widget.loggedInUser.uid,
        loggedInUid: widget.loggedInUser.uid);
  }

  _updateUnreadMessages(
      {BuildContext context,
      String chatId,
      bool amIUser1,
      String loggedInUid}) {
    // subtract the number of unread messages from the global total
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    cloudFirestoreService.updateUserTotalUnreadMessages(
        chatId: chatId, isUser1: amIUser1, uid: loggedInUid);
    // set to 0 the number of unread messages of the chat when user leaves the chat
    cloudFirestoreService.resetUnreadMessagesInChat(
        chatId: chatId, isUser1: amIUser1);
  }
}
