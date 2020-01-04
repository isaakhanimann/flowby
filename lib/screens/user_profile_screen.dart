import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/settings_screen.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  static const String id = 'user_profile_screen';

  static var showSkills = true;

  @override
  Widget build(BuildContext context) {
    var loggedInUser = Provider.of<User>(context);
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
                            future: FirebaseConnection.getImageUrl(
                                fileName: loggedInUser.email),
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
                                loggedInUser.username,
                                style: kMiddleTitleTextStyle,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Text(
                                    '${loggedInUser.distanceInKm.toString()} km'),
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
                          '${loggedInUser.skillRate} CHF/h',
                          style: kSmallTitleTextStyle,
                        ),
                      ],
                    ),
                    Text(
                      showSkills
                          ? loggedInUser.skillHashtags
                          : loggedInUser.wishHashtags,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Wishes',
                          style: kMiddleTitleTextStyle,
                        ),
                        Text(
                          '${loggedInUser.wishRate} CHF/h',
                          style: kSmallTitleTextStyle,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      !showSkills
                          ? loggedInUser.skillHashtags
                          : loggedInUser.wishHashtags,
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
          ],
        ),
      ),
    );
  }
}
