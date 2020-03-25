import 'package:Flowby/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:Flowby/widgets/top_middle_bottom_text.dart';
import 'package:Flowby/constants.dart';

class ExplanationLookingForSkillTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: double.infinity,
      color: kLightDefaultProfilePicColor,
      child: TopMiddleBottomText(
        topText: AppLocalizations.of(context).translate('looking_for_skill'),
        middleText:
            AppLocalizations.of(context).translate('search_all_skills_and_see'),
        bottomText: AppLocalizations.of(context).translate('chat_and_meet'),
      ),
    );
  }
}
