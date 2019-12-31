import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/chat_screen.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewProfileScreen extends StatelessWidget {
  static const String id = 'view_profile_screen';
  final User user;
  final bool showSkills;

  ViewProfileScreen({@required this.user, this.showSkills = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          color: kDarkGreenColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('${user.distanceInKm.toString()} km'),
                        Icon(CupertinoIcons.location)
                      ],
                    ),
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
              text: 'Chat',
              color: kDarkGreenColor,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true)
                    .push(CupertinoPageRoute<void>(
                  builder: (context) {
                    return ChatScreen(otherUser: user);
                  },
                  fullscreenDialog: true,
                ));
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
