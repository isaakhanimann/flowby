import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/edit_profile_screen.dart';
import 'package:float/screens/settings_screen.dart';
import 'package:float/screens/show_profile_picture_screen.dart';
import 'package:float/services/firebase_cloud_firestore_service.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:float/widgets/sign_in_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  Column _buildListOfTextFields({Map<dynamic, dynamic> skillsOrWishes}) {
    List<Widget> rows = [];
    for (String key in skillsOrWishes.keys) {
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                key,
                style: kSmallTitleTextStyle,
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                skillsOrWishes[key],
                style: kSmallTitleTextStyle,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      );
      rows.add(SizedBox(
        height: 10,
      ));
    }

    return Column(
      children: rows,
    );
  }

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
          bool canShowSkills =
              user.hasSkills && user.skills != null && user.skills.isNotEmpty;
          bool canShowWishes =
              user.hasWishes && user.wishes != null && user.wishes.isNotEmpty;

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
                                Feather.settings,
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
                            Center(
                              child: Hero(
                                tag: user.imageFileName,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(CupertinoPageRoute(
                                            builder: (context) =>
                                                ShowProfilePictureScreen(
                                                  profilePictureUrl:
                                                      'https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F${user.imageFileName}?alt=media',
                                                  otherUsername: user.username,
                                                  heroTag: user.imageFileName,
                                                )));
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F${user.imageFileName}?alt=media",
                                    imageBuilder: (context, imageProvider) {
                                      return CircleAvatar(
                                          radius: 60,
                                          backgroundColor: Colors.grey,
                                          backgroundImage: imageProvider);
                                    },
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          kDefaultProfilePicColor),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
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
                        if (!canShowSkills && !canShowWishes)
                          Text(
                            '(Your profile is invisible)',
                            textAlign: TextAlign.center,
                          ),
                        if (canShowSkills)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Skills',
                                    style: kMiddleTitleTextStyle,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '${user.skillRate} CHF/h',
                                      ),
                                      SizedBox(width: 15),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              _buildListOfTextFields(
                                  skillsOrWishes: user.skills)
                            ],
                          ),
                        if (canShowWishes)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Wishes',
                                    style: kMiddleTitleTextStyle,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '${user.wishRate} CHF/h',
                                      ),
                                      SizedBox(width: 15),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              _buildListOfTextFields(
                                  skillsOrWishes: user.wishes)
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
