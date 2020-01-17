import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/edit_profile_screen.dart';
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
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                heightFactor: 1.2,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: NetworkImage(
                                      'https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F${user.imageFileName}?alt=media'),
                                ),
                              ),
                              Center(
                                child: Text(
                                  user.username,
                                  style: kMiddleTitleTextStyle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          if (user.bio != null && user.bio != '')
                            Center(
                              child: Text(
                                user.bio,
                                style: kSmallTitleTextStyle,
                              ),
                            ),
                          SizedBox(
                            height: 15,
                          ),
                          if (user.hasSkills)
                            Column(
                              children: <Widget>[
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
                                      style: kSmallTitleTextStyle,
                                    ),
                                  ],
                                ),
                                Text(
                                  user.skillHashtags,
                                ),
                              ],
                            ),
                          if (user.hasWishes)
                            Column(
                              children: <Widget>[
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
                                      style: kSmallTitleTextStyle,
                                    ),
                                  ],
                                ),
                                Text(
                                  user.wishHashtags,
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
                  RoundedButton(
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
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
