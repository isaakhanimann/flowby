import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/show_profile_picture_screen.dart';
import 'package:Flowby/widgets/profile_picture.dart';
import 'package:Flowby/widgets/route_transitions/scale_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/models/search_mode.dart';

class ListViewOfUserInfos extends StatelessWidget {
  final User user;
  final String heroTag;

  ListViewOfUserInfos({@required this.user, this.heroTag = 'notnulltag'});

  @override
  Widget build(BuildContext context) {
    final searchMode = Provider.of<SearchMode>(context);

    bool areSkillsEmpty = user.skills == null || user.skills.isEmpty;

    bool areWishesEmpty = user.wishes == null || user.wishes.isEmpty;

    bool showSkillsAndWishes = false;
    bool showJustSkills = false;
    bool showJustWishes = false;
    bool showHidden = false;
    bool showInvisible = false;
    if (user.isHidden) {
      showHidden = true;
    } else if (areSkillsEmpty && areWishesEmpty) {
      showInvisible = true;
    } else if (!areWishesEmpty && !areSkillsEmpty) {
      showSkillsAndWishes = true;
    } else if (!areWishesEmpty) {
      showJustWishes = true;
    } else if (!areSkillsEmpty) {
      showJustSkills = true;
    }

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
                  imageUrl: user.imageUrl,
                  otherUsername: user.username,
                  heroTag: heroTag,
                )));
              },
              child: ProfilePicture(
                  imageUrl: user.imageUrl, radius: 60, heroTag: heroTag),
            ),
          ),
          if (user.distanceInKm != null &&
              user.distanceInKm != kAlmostInfiniteDistanceInKm &&
              user.currentCity != null &&
              user.currentCity != '')
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
                    ' ' +
                        user.currentCity +
                        ', ' +
                        user.distanceInKm.toString() +
                        'km',
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
          //if the user has both wishes and skills we show both sections
          if (showSkillsAndWishes)
            SkillAndWishSection(
              skills: user.skills,
              wishes: user.wishes,
              isSkillChosenInitially: searchMode.mode == Mode.searchSkills,
            ),
          //if the user just has skills just show those
          if (showJustSkills)
            SkillSection(
              skills: user.skills,
            ),
          //if the user just has wishes just show those
          if (showJustWishes)
            WishSection(
              wishes: user.wishes,
            ),
          if (showHidden)
            Text(
              AppLocalizations.of(context).translate("profile_hidden"),
              textAlign: TextAlign.center,
            ),
          if (showInvisible)
            Text(
              AppLocalizations.of(context).translate("profile_invisible"),
              textAlign: TextAlign.center,
            ),
          SizedBox(
            height: 90,
          ),
        ],
      ),
    );
  }
}

class SkillAndWishSection extends StatefulWidget {
  final List<SkillOrWish> skills;
  final List<SkillOrWish> wishes;
  final bool isSkillChosenInitially;

  SkillAndWishSection(
      {@required this.skills,
      @required this.wishes,
      @required this.isSkillChosenInitially});

  @override
  _SkillAndWishSectionState createState() => _SkillAndWishSectionState();
}

class _SkillAndWishSectionState extends State<SkillAndWishSection> {
  bool isSkillChosen;

  @override
  void initState() {
    super.initState();
    isSkillChosen = widget.isSkillChosenInitially;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        CupertinoSegmentedControl(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          groupValue: isSkillChosen,
          onValueChanged: _switch,
          children: <bool, Widget>{
            true: Text(AppLocalizations.of(context).translate('skills'),
                style: kHomeSwitchTextStyle),
            false: Text(AppLocalizations.of(context).translate('wishes'),
                style: kHomeSwitchTextStyle),
          },
        ),
        SizedBox(height: 20),
        if (isSkillChosen)
          SkillSection(
            skills: widget.skills,
          ),
        if (!isSkillChosen)
          WishSection(
            wishes: widget.wishes,
          ),
      ],
    );
  }

  _switch(bool newChoice) {
    setState(() {
      isSkillChosen = newChoice;
    });
  }
}

class SkillSection extends StatelessWidget {
  final List<SkillOrWish> skills;

  SkillSection({@required this.skills});

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
              AppLocalizations.of(context).translate("skills"),
              style: kSkillsTitleTextStyle,
            ),
            SizedBox(height: 10),
            ListOfTexts(skillsOrWishes: skills)
          ],
        ),
      ),
    );
  }
}

class WishSection extends StatelessWidget {
  final List<SkillOrWish> wishes;

  WishSection({@required this.wishes});

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
              AppLocalizations.of(context).translate("wishes"),
              style: kSkillsTitleTextStyle,
            ),
            SizedBox(height: 10),
            ListOfTexts(skillsOrWishes: wishes)
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
