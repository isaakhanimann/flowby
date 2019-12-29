import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewProfileScreen extends StatelessWidget {
  static const String id = 'view_profile_screen';
  final User user;

  ViewProfileScreen({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  children: <Widget>[
                    Center(
                      heightFactor: 1.2,
                      child: FutureBuilder(
                        future: FirebaseConnection.getImageUrl(
                            fileName: user.email),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            String imageUrl = snapshot.data;
                            return CircleAvatar(
                              radius: 30,
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
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        user.username,
                        style: kBigTitleTextStyle,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Skills',
                      style: kMiddleTitleTextStyle,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Hourly rate',
                      style: kSmallTitleTextStyle,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Wishes',
                      style: kMiddleTitleTextStyle,
                    ),
                    Text(
                      'Add hashtags to let people know what they can help you with',
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Hourly rate',
                      style: kSmallTitleTextStyle,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
            RoundedButton(
              text: 'Chat',
              color: kDarkGreenColor,
              onPressed: () async {
                print('Chat button pressed');
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
