import 'package:flutter/cupertino.dart';
import 'package:Flowby/widgets/top_middle_bottom_text.dart';
import 'package:flutter/material.dart';
import 'package:Flowby/constants.dart';

class ExplanationDidntFindSkillTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: double.infinity,
      color: kLightYellowColor,
      child: TopMiddleBottomText(
        topText: 'Didn’t find anyone with the skill you were looking for?',
        middleText:
            'Add a wish\nSpecify the topic & description\nAdd the price you would be willing to pay for it',
        bottomText: 'Wait to get notified',
      ),
    );
  }
}
