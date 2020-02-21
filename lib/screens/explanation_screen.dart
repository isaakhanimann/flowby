import 'package:flutter/cupertino.dart';
import 'package:Flowby/screens/explanation_provide_skill_tab.dart';
import 'package:Flowby/screens/explanation_looking_for_skill_tab.dart';
import 'package:Flowby/screens/explanation_didnt_find_skill_tab.dart';
import 'package:Flowby/screens/explanation_see_distance_tab.dart';

class ExplanationScreen extends StatelessWidget {
  static const String id = 'explanation_screen';
  final pageController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
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
        SafeArea(
          child: CupertinoButton(
            child: Text('Skip'),
            onPressed: () {
              print('skip pressed');
            },
          ),
        )
      ],
    );
  }
}
