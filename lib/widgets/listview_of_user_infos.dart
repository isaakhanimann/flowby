import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/show_profile_picture_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListViewOfUserInfos extends StatelessWidget {
  ListViewOfUserInfos({@required this.user, this.heroTag});

  final User user;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    bool canShowSkills =
        user.hasSkills && user.skills != null && user.skills.isNotEmpty;
    bool canShowWishes =
        user.hasWishes && user.wishes != null && user.wishes.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Center(
            child: Hero(
              transitionOnUserGestures: true,
              tag: heroTag ?? user.imageFileName,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true)
                      .push(CupertinoPageRoute(
                          builder: (context) => ShowProfilePictureScreen(
                                profilePictureUrl:
                                    'https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F${user.imageFileName}?alt=media',
                                otherUsername: user.username,
                                heroTag: heroTag ?? user.imageFileName,
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
                  placeholder: (context, url) => CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                _buildListOfTextFields(skillsOrWishes: user.skills)
              ],
            ),
          if (canShowWishes)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                _buildListOfTextFields(skillsOrWishes: user.wishes)
              ],
            ),
          SizedBox(
            height: 70,
          ),
        ],
      ),
    );
  }

  Column _buildListOfTextFields({Map<dynamic, dynamic> skillsOrWishes}) {
    List<Widget> rows = [];
    for (String key in skillsOrWishes.keys) {
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Text(
                key,
                style: kSmallTitleTextStyle,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              flex: 8,
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
}
