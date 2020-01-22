import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/chat_screen.dart';
import 'package:float/screens/choose_signup_or_login_screen.dart';
import 'package:float/screens/profile_picture_screen.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 15.0,
                    ),
                    Stack(
                      children: <Widget>[
                        CupertinoButton(
                          child: Icon(
                            CupertinoIcons.back,
                            size: 30,
                          ),
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Center(
                          child: Hero(
                            tag: heroTag,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            ProfilePictureScreen(
                                              profilePictureUrl:
                                                  'https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F${user.imageFileName}?alt=media',
                                              otherUsername: user.username,
                                              heroTag: heroTag,
                                            )));
                              },
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F${user.imageFileName}?alt=media'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (user.distanceInKm != null)
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text('${user.distanceInKm.toString()} km'),
                            Icon(
                              CupertinoIcons.location,
                              color: kDefaultProfilePicColor,
                            )
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        user.username,
                        style: kMiddleTitleTextStyle,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (user.bio != null && user.bio != '')
                      Text(
                        user.bio,
                        style: kSmallTitleTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    SizedBox(
                      height: 15,
                    ),
                    if (user.hasSkills)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Skills',
                                style: kMiddleTitleTextStyle,
                              ),
                              Text(
                                '${user.skillRate} CHF/h',
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            user.skillHashtags,
                            style: kSmallTitleTextStyle,
                          ),
                        ],
                      ),
                    if (user.hasWishes)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Wishes',
                                style: kMiddleTitleTextStyle,
                              ),
                              Text(
                                '${user.wishRate} CHF/h',
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            user.wishHashtags,
                            style: kSmallTitleTextStyle,
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: RoundedButton(
                text: loggedInUser == null ? 'Signin to Chat' : 'Chat',
                color: ffDarkBlue,
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
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
