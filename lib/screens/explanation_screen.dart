import 'package:Flowby/screens/navigation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:Flowby/screens/explanation_provide_skill_tab.dart';
import 'package:Flowby/screens/explanation_looking_for_skill_tab.dart';
import 'package:Flowby/screens/explanation_didnt_find_skill_tab.dart';
import 'package:Flowby/screens/explanation_see_distance_tab.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class ExplanationScreen extends StatelessWidget {
  static const String id = 'explanation_screen';

  final pages = [
    Container(child: ExplanationProvideSkillTab()),
    Container(child: ExplanationLookingForSkillTab()),
    Container(child: ExplanationDidntFindSkillTab()),
    Container(child: ExplanationSeeDistanceTab())
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        LiquidSwipe(
          pages: pages,
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
      ],
    );
  }
}
