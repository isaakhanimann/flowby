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
        !user.isHidden && user.skills != null && user.skills.isNotEmpty;
    bool canShowWishes =
        !user.isHidden && user.wishes != null && user.wishes.isNotEmpty;

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
                  imageVersionNumber: user.imageVersionNumber,
                  otherUsername: user.username,
                  heroTag: heroTag ?? user.imageFileName,
                )));
              },
              child: CachedNetworkImage(
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F${user.imageFileName}?alt=media&version=${user.imageVersionNumber}",
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
                  Icon(
                    Feather.navigation,
                    size: 14,
                  ),
                  Text(
                    ' ' + user.distanceInKm.toString() + 'km',
                  ),
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
            SkillOrWishSection(
              skillsOrWishes: user.skills,
              title: 'Skills',
            ),
          SizedBox(height: 15),
          if (canShowWishes)
            SkillOrWishSection(
              skillsOrWishes: user.wishes,
              title: 'Wishes',
            ),
          SizedBox(
            height: 90,
          ),
        ],
      ),
    );
  }
}

class SkillOrWishSection extends StatelessWidget {
  final List<SkillOrWish> skillsOrWishes;
  final String title;

  SkillOrWishSection({@required this.skillsOrWishes, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: kCardBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: kSkillsTitleTextStyle,
            ),
            SizedBox(height: 10),
            ListOfTexts(skillsOrWishes: skillsOrWishes)
          ],
        ),
      ),
    );
  }
}

class ListOfTexts extends StatelessWidget {
  final List<SkillOrWish> skillsOrWishes;

  ListOfTexts({@required this.skillsOrWishes});

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    for (SkillOrWish skillOrWish in skillsOrWishes) {
      rows.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Text(
                    skillOrWish.keywords,
                    style: kKeywordHeaderTextStyle,
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Text(
                    skillOrWish.price,
                    style: kKeywordHeaderTextStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.0),
            Text(
              skillOrWish.description,
              style: kSmallTitleTextStyle,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 15.0),
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
