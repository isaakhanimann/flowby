import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/show_profile_picture_screen.dart';
import 'package:Flowby/widgets/route_transitions/scale_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ListViewOfUserInfos extends StatelessWidget {
  ListViewOfUserInfos({@required this.user, this.heroTag});

  final User user;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    bool canShowSkills =
        user.hasSkills && user.skillz != null && user.skillz.isNotEmpty;
    bool canShowWishes =
        user.hasWishes && user.wishez != null && user.wishez.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(ScaleRoute(
                    page: ShowProfilePictureScreen(
                  imageFileName: user.imageFileName,
                  otherUsername: user.username,
                  heroTag: heroTag ?? user.imageFileName,
                )));
              },
              child: CachedNetworkImage(
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F${user.imageFileName}?alt=media",
                imageBuilder: (context, imageProvider) {
                  return Hero(
                    transitionOnUserGestures: true,
                    tag: heroTag ?? user.imageFileName,
                    child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey,
                        backgroundImage: imageProvider),
                  );
                },
                placeholder: (context, url) => CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          if (user.distanceInKm != null)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text(
                    user.distanceInKm.toString() + ' km ',
                  ),
                  Icon(
                    Feather.map_pin,
                    size: 14,
                  )
                ],
              ),
            ),
          SizedBox(
            height: 15.0,
          ),
          Center(
            child: Text(
              user.username,
              style: kUsernameTitleTextStyle,
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
                Text(
                  'Skills',
                  style: kSkillsTitleTextStyle,
                ),
                SizedBox(height: 10),
                _buildListOfTextFields(skillsOrWishes: user.skillz)
              ],
            ),
          if (canShowWishes)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Wishes',
                  style: kSkillsTitleTextStyle,
                ),
                SizedBox(height: 10),
                _buildListOfTextFields(skillsOrWishes: user.wishez)
              ],
            ),
          SizedBox(
            height: 70,
          ),
        ],
      ),
    );
  }

  Column _buildListOfTextFields({List<SkillOrWish> skillsOrWishes}) {
    List<Widget> rows = [];
    for (SkillOrWish skillOrWish in skillsOrWishes) {
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Text(
                skillOrWish.keywords,
                style: kSmallTitleTextStyle,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              flex: 8,
              child: Text(
                skillOrWish.description,
                style: kSmallTitleTextStyle,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              flex: 3,
              child: Text(
                skillOrWish.price,
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
