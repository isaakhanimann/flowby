import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/edit_profile_screen.dart';
import 'package:float/screens/settings_tab.dart';
import 'package:float/services/firebase_cloud_firestore_service.dart';
import 'package:float/services/firebase_storage_service.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:float/widgets/sign_in_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatelessWidget {
  static const String id = 'user_profile_screen';

  static var showSkills = true;

  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<FirebaseUser>(context, listen: false);
    if (loggedInUser == null) {
      return Center(child: SignInButton());
    }
    final storageService =
        Provider.of<FirebaseStorageService>(context, listen: false);
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
                                              'assets/images/default-profile-pic.jpg'),
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
                              Center(
                                child: Text(
                                  user.username,
                                  style: kMiddleTitleTextStyle,
                                ),
                              ),
                              IconButton(
                                color: Colors.black,
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: false)
                                      .push(
                                    CupertinoPageRoute<void>(
                                      builder: (context) {
                                        return SettingsTab();
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
                              '${user.bio}',
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
                            showSkills ? user.skillHashtags : user.wishHashtags,
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
                      Navigator.of(context, rootNavigator: false).push(
                        MaterialPageRoute<void>(
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
