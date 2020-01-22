import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/choose_signup_or_login_screen.dart';
import 'package:float/screens/edit_profile_screen.dart';
import 'package:float/services/firebase_auth_service.dart';
import 'package:float/screens/settings_screen.dart';
import 'package:float/services/firebase_cloud_firestore_service.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:float/widgets/sign_in_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<FirebaseUser>(context, listen: false);
    if (loggedInUser == null) {
      return Center(child: SignInButton());
    }
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    return FutureBuilder(
        future: cloudFirestoreService.getUser(uid: loggedInUser.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          User user = snapshot.data;
          return SafeArea(
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
                                CupertinoIcons.settings,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).push(
                                  CupertinoPageRoute<void>(
                                    builder: (context) {
                                      return SettingsScreen(
                                        loggedInUser: loggedInUser,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            /*CupertinoButton(
                              child: Icon(
                                Icons.exit_to_app,
                                size: 30,
                              ),
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                final authService =
                                    Provider.of<FirebaseAuthService>(context);
                                authService.signOut();
                                
                                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                                  CupertinoPageRoute(
                                      builder: (BuildContext context) =>
                                          ChooseSignupOrLoginScreen()),
                                  (Route<dynamic> route) => false,
                                );
                              },
                            ),
                            */

                            Center(
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F${user.imageFileName}?alt=media'),
                              ),
                            ),
                          ],
                          alignment: Alignment.topRight,
                        ),
                        SizedBox(
                          height: 15.0,
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
                        if (!user.hasSkills && !user.hasWishes)
                          Text(
                            '(Your profile is invisible)',
                            textAlign: TextAlign.center,
                          ),
                        if (user.hasSkills)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              if (user.skillHashtags != null &&
                                  user.skillHashtags != '')
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                              if (user.skillHashtags != null &&
                                  user.skillHashtags != '')
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
                              if (user.wishHashtags != null &&
                                  user.wishHashtags != '')
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                              if (user.wishHashtags != null &&
                                  user.wishHashtags != '')
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
                    text: 'Edit your profile',
                    color: ffDarkBlue,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute<void>(
                          builder: (context) {
                            return EditProfileScreen(
                                loggedInUser: loggedInUser);
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        });
  }
}
