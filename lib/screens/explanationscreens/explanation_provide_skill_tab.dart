import 'package:Flowby/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:Flowby/widgets/top_middle_bottom_text.dart';

class ExplanationProvideSkillTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: double.infinity,
      color: kLightBlueColor,
      child: TopMiddleBottomText(
        topText: 'Want to provide a skill?',
        middleText:
            'Add a skill\nSpecify the topic & description\nWhat do you want in exchange?',
        bottomText:
            'Wait to get notified or actively look for people who have wished for it',
      ),
    );
  }
}
