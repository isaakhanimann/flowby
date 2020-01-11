import 'package:float/constants.dart';
import 'package:float/screens/settings_screen.dart';
import 'package:float/services/firebase_storage_service.dart';
import 'package:float/services/firebase_cloud_firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:float/screens/edit_user_profile_screen.dart';

import 'package:float/models/user.dart';

class UserProfileScreen extends StatelessWidget {
  static const String id = 'user_profile_screen';

  static var showSkills = true;
  User user;
  FirebaseUser loggedInUser;
  FirebaseStorageService storageService;

  void _getUserData(BuildContext context) async {
    final cloudFirestoreService =
    Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    final storageService =
    Provider.of<FirebaseStorageService>(context, listen: false);
    final loggedInUser = Provider.of<FirebaseUser>(context, listen: false);
    String uid = loggedInUser.uid;
    String imgUrl = await storageService.getImageUrl(fileName: uid);
    User user = await cloudFirestoreService.getUser(uid: uid);
  }

  @override
  Widget build(BuildContext context) {

    _getUserData(context);
    if (loggedInUser.uid == null) {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }

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
                          child: FutureBuilder(
                            future: storageService.getImageUrl(
                                fileName: user.uid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                String imageUrl = snapshot.data;
                                if (imageUrl == null) {
                                  return CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: AssetImage(
                                        'images/default-profile-pic_old.jpg'),
                                  );
                                }
                                return CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: NetworkImage(imageUrl),
                                );
                              }
                              return CircleAvatar(
                                backgroundColor: Colors.grey,
                              );
                            },
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Center(
                              child: Text(
                                user.username,
                                style: kMiddleTitleTextStyle,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Text(
                                    '${user.distanceInKm.toString()} km'),
                                Icon(CupertinoIcons.location)
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          color: Colors.black,
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute<void>(
                                builder: (context) {
                                  return SettingsScreen();
                                },
                              ),
                            );
                          },
                          icon: Icon(Icons.settings),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
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
                    Row(
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
                    ),
                    Text(
                      showSkills
                          ? user.skillHashtags
                          : user.wishHashtags,
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
                          style: kSmallTitleTextStyle,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      !showSkills
                          ? user.skillHashtags
                          : user.wishHashtags,
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
                  MaterialPageRoute<void>(
                    builder: (context) {
                      return EditUserProfileScreen();
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
