import 'package:Flowby/app_localizations.dart';
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
            if (!(loggedInUser?.uid == user.uid))
              Positioned(
                bottom: 20,
                child: RoundedButton(
                  text: loggedInUser == null
                      ? AppLocalizations.of(context)
                          .translate('sign_in_to_chat')
                      : AppLocalizations.of(context).translate('chat'),
                  color: kDefaultProfilePicColor,
                  textColor: kBlueButtonColor,
                  onPressed: () async {
                    if (loggedInUser == null) {
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                        CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                ChooseSigninScreen()),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      await Navigator.of(context).push(
                        CupertinoPageRoute<void>(
                          builder: (context) {
                            return ChatScreen(
                              loggedInUser: loggedInUser,
                              otherUser: user,
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
