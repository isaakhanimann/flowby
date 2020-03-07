import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/chat_screen.dart';
import 'package:Flowby/screens/choose_signin_screen.dart';
import 'package:Flowby/widgets/listview_of_user_infos.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ViewProfileScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            ListViewOfUserInfos(user: user, heroTag: heroTag),
            Positioned(
              bottom: 20,
              child: RoundedButton(
                text: loggedInUser == null ? 'Sign In to Chat' : 'Chat',
                color: kDefaultProfilePicColor,
                textColor: kBlueButtonColor,
                onPressed: () async {
                  if (loggedInUser == null) {
                    Navigator.of(context).push(
                      CupertinoPageRoute<void>(
                        builder: (context) {
                          return ChooseSigninScreen();
                        },
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      CupertinoPageRoute<void>(
                        builder: (context) {
                          return ChatScreen(
                            loggedInUid: loggedInUser.uid,
                            otherUid: user.uid,
                            otherUsername: user.username,
                            otherImageFileName: user.imageFileName,
                            otherImageVersionNumber: user.imageVersionNumber,
                            heroTag: heroTag,
                          );
                        },
                      ),
                    );
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
    );
  }
}

class ViewProfileScreenFromChat extends StatelessWidget {
  static const String id = 'view_profile_screen_from_chat';
  final User user;
  final String heroTag;
  final bool showSkills;

  ViewProfileScreenFromChat({
    @required this.user,
    @required this.heroTag,
    this.showSkills = true,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            ListViewOfUserInfos(user: user, heroTag: heroTag),
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
    );
  }
}
