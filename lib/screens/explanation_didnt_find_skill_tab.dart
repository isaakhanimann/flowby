import 'package:flutter/cupertino.dart';
import 'package:Flowby/widgets/top_middle_bottom_text.dart';

class ExplanationDidntFindSkillTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: CupertinoColors.systemTeal,
      child: TopMiddleBottomText(
        topText: 'Didn’t find anyone with the skill you were looking for?',
        middleText:
            'Add a wish, specify the topic & description and the price you would be willing to pay for it',
        bottomText: 'Wait to get notified',
      ),
    );
  }
}
