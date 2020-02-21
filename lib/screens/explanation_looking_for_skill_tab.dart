import 'package:flutter/cupertino.dart';
import 'package:Flowby/widgets/top_middle_bottom_text.dart';

class ExplanationLookingForSkillTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: double.infinity,
      color: CupertinoColors.activeGreen,
      child: TopMiddleBottomText(
          topText:
              'Looking for a certain skill (ex. tutor, tandem, fitnessbuddy,...)?',
          middleText: 'Search all skills and see which users offer them',
          bottomText: 'Chat and meet'),
    );
  }
}
