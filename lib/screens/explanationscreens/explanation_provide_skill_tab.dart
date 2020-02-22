import 'package:flutter/cupertino.dart';
import 'package:Flowby/widgets/top_middle_bottom_text.dart';

class ExplanationProvideSkillTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: double.infinity,
      color: CupertinoColors.systemYellow,
      child: TopMiddleBottomText(
        topText: 'Want to provide a skill?',
        middleText:
            'Add a skill\nSpecify the topic & description\nHow much you want to get paid for it?',
        bottomText:
            'Wait to get notified or actively look for people who have wished for it',
      ),
    );
  }
}
