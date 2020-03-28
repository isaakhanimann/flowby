import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/constants.dart';
import 'package:Flowby/screens/navigation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:Flowby/screens/explanationscreens/explanation_provide_skill_tab.dart';
import 'package:Flowby/screens/explanationscreens/explanation_looking_for_skill_tab.dart';
import 'package:Flowby/screens/explanationscreens/explanation_didnt_find_skill_tab.dart';
import 'package:Flowby/screens/explanationscreens/explanation_see_distance_tab.dart';
import 'package:Flowby/screens/explanationscreens/explanation_announcements_tab.dart';
import 'package:Flowby/models/search_mode.dart';
import 'package:provider/provider.dart';

class ExplanationScreen extends StatefulWidget {
  static const String id = 'explanation_screen';

  final bool popScreen;

  ExplanationScreen({this.popScreen = false});

  @override
  _ExplanationScreenState createState() => _ExplanationScreenState();
}

class _ExplanationScreenState extends State<ExplanationScreen> {
  int selectedPage = 0;
  int numberOfPages;
  List<Container> pages;

  @override
  Widget build(BuildContext context) {
    final searchMode = Provider.of<SearchMode>(context, listen: false);

    if (searchMode.mode == Mode.searchWishes) {
      numberOfPages = 3;
      pages = [
        Container(
          child: ExplanationProvideSkillTab(),
        ),
        Container(child: ExplanationAnnouncementsTab()),
        Container(
          child: ExplanationSeeDistanceTab(),
        )
      ];
    } else if (searchMode.mode == Mode.searchSkills) {
      numberOfPages = 4;
      pages = [
        Container(child: ExplanationLookingForSkillTab()),
        Container(child: ExplanationDidntFindSkillTab()),
        Container(child: ExplanationAnnouncementsTab()),
        Container(child: ExplanationSeeDistanceTab())
      ];
    } else {
      // loggedInUsersRole == null
      numberOfPages = 5;
      pages = [
        Container(child: ExplanationProvideSkillTab()),
        Container(child: ExplanationLookingForSkillTab()),
        Container(child: ExplanationDidntFindSkillTab()),
        Container(child: ExplanationAnnouncementsTab()),
        Container(child: ExplanationSeeDistanceTab())
      ];
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        LiquidSwipe(
          pages: pages,
          onPageChangeCallback: _onPageChangeCallback,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: SafeArea(
            child: CupertinoButton(
              padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: Text(
                AppLocalizations.of(context).translate('skip'),
                style: kSkipTextStyle,
              ),
              onPressed: () {
                widget.popScreen
                    ? Navigator.of(context, rootNavigator: true).pop()
                    : Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                        CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                NavigationScreen()),
                        (Route<dynamic> route) => false,
                      );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          child: SafeArea(
            child: PageIndicator(
                numberOfPages: numberOfPages, selectedPage: selectedPage),
          ),
        ),
      ],
    );
  }

  _onPageChangeCallback(int pageNumber) {
    setState(() {
      selectedPage = pageNumber;
    });
  }
}

class PageIndicator extends StatelessWidget {
  final int numberOfPages;
  final int selectedPage;

  PageIndicator({@required this.numberOfPages, @required this.selectedPage});

  @override
  Widget build(BuildContext context) {
    List<Widget> listOfDots = [];
    for (int i = 0; i < numberOfPages; i++) {
      if (i == selectedPage) {
        listOfDots.add(
          Container(
            height: 15,
            width: 15,
            margin: EdgeInsets.all(2),
            decoration:
                BoxDecoration(color: kBlueButtonColor, shape: BoxShape.circle),
          ),
        );
      } else {
        listOfDots.add(Container(
          height: 10,
          width: 10,
          margin: EdgeInsets.all(2),
          decoration:
              BoxDecoration(color: kBlueButtonColor, shape: BoxShape.circle),
        ));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: listOfDots,
    );
  }
}
