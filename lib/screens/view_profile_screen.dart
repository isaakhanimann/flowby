import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/chat_screen.dart';
import 'package:Flowby/screens/choose_signup_or_login_screen.dart';
import 'package:Flowby/widgets/listview_of_user_infos.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ViewProfileScreen extends StatelessWidget {
  static const String id = 'view_profile_screen';
  final User user;
  final String heroTag;
  final FirebaseUser loggedInUser;
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
            ListViewOfUserInfos(
              user: user,
              heroTag: heroTag,
            ),
            RoundedButton(
              text: loggedInUser == null ? 'Signin to Chat' : 'Chat',
              color: kBlueButtonColor,
              textColor: Colors.white,
              onPressed: () async {
                if (loggedInUser == null) {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute<void>(
                      builder: (context) {
                        return ChooseSignupOrLoginScreen();
                      },
                    ),
                  );
                } else {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute<void>(
                      builder: (context) {
                        return ChatScreen(
                          loggedInUid: loggedInUser.uid,
                          otherUid: user.uid,
                          otherUsername: user.username,
                          otherImageFileName: user.imageFileName,
                          heroTag: heroTag,
                        );
                      },
                    ),
                  );
                }
              },
            ),
            Positioned(
              top: 0,
              left: 0,
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
