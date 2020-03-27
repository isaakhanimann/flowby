import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/show_profile_picture_screen.dart';
import 'package:Flowby/widgets/profile_picture.dart';
import 'package:Flowby/widgets/route_transitions/scale_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:Flowby/models/role.dart';

class ListViewOfUserInfos extends StatelessWidget {
  final User user;
  final String heroTag;

  ListViewOfUserInfos({@required this.user, this.heroTag});

  @override
  Widget build(BuildContext context) {
    bool areSkillsEmpty = user.skills == null || user.skills.isEmpty;

    bool areWishesEmpty = user.wishes == null || user.wishes.isEmpty;

    bool isProvider = user.role == Role.provider;
    bool isConsumer = user.role == Role.consumer;

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
              child: ProfilePicture(
                  imageFileName: user.imageFileName,
                  imageVersionNumber: user.imageVersionNumber,
                  radius: 60,
                  heroTag: heroTag ?? user.imageFileName),
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
                    style: kDistanceTextStyle,
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
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (user.bio != null && user.bio != '')
            Text(
              user.bio,
              style: kDescriptionTextStyle,
              textAlign: TextAlign.center,
            ),
          SizedBox(
            height: 15,
          ),
          if (user.isHidden)
            Text(
              AppLocalizations.of(context).translate("profile_hidden"),
              textAlign: TextAlign.center,
            ),
          if (!user.isHidden && isProvider && areSkillsEmpty)
            Text(
              AppLocalizations.of(context).translate("profile_invisible_1"),
              textAlign: TextAlign.center,
            ),
          if (!user.isHidden && isProvider && !areSkillsEmpty)
            SkillOrWishSection(
              skillsOrWishes: user.skills,
              title: AppLocalizations.of(context).translate("skills"),
            ),
          if (!user.isHidden && isConsumer && areWishesEmpty)
            Text(
              AppLocalizations.of(context).translate("profile_invisible_2"),
              textAlign: TextAlign.center,
            ),
          if (!user.isHidden && isConsumer && !areWishesEmpty)
            SkillOrWishSection(
              skillsOrWishes: user.wishes,
              title: AppLocalizations.of(context).translate("wishes"),
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
