import 'package:Flowby/screens/navigation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:Flowby/screens/explanation_provide_skill_tab.dart';
import 'package:Flowby/screens/explanation_looking_for_skill_tab.dart';
import 'package:Flowby/screens/explanation_didnt_find_skill_tab.dart';
import 'package:Flowby/screens/explanation_see_distance_tab.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ExplanationScreen extends StatelessWidget {
  static const String id = 'explanation_screen';
  final pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        PageView(
          controller: pageController,
          children: <Widget>[
            ExplanationProvideSkillTab(),
            ExplanationLookingForSkillTab(),
            ExplanationDidntFindSkillTab(),
            ExplanationSeeDistanceTab()
          ],
        ),
        Positioned(
          bottom: 30,
          right: 20,
          child: CupertinoButton(
            child: Text('Skip'),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute<void>(
                  builder: (context) {
                    return NavigationScreen();
                  },
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 50,
          child: SmoothPageIndicator(
            controller: pageController, // PageController
            count: 4,
            effect: WormEffect(
              dotColor: CupertinoColors.white,
            ),
            // your preferred effect
          ),
        )
      ],
    );
  }
}
