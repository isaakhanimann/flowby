import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/chat_screen.dart';
import 'package:float/screens/choose_signup_or_login_screen.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CupertinoButton(
                          child: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Center(
                          heightFactor: 1.2,
                          child: Hero(
                            tag: heroTag,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                  'https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F${user.imageFileName}?alt=media'),
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text('${user.distanceInKm.toString()} km'),
                            Icon(CupertinoIcons.location)
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        user.username,
                        style: kBigTitleTextStyle,
                      ),
                    ),
                    Center(
                      child: Text(
                        'This is the description',
                        style: kSmallTitleTextStyle,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    showSkills
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Skills',
                                style: kMiddleTitleTextStyle,
                              ),
                              Text(
                                '${user.skillRate} CHF/h',
                                style: kSmallTitleTextStyle,
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Wishes',
                                style: kMiddleTitleTextStyle,
                              ),
                              Text(
                                '${user.wishRate} CHF/h',
                                style: kSmallTitleTextStyle,
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      showSkills ? user.skillHashtags : user.wishHashtags,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
            RoundedButton(
              text: loggedInUser == null ? 'Signin to Chat' : 'Chat',
              color: kDarkGreenColor,
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
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
