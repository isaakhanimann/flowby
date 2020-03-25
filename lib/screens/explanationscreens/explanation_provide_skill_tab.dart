import 'package:Flowby/app_localizations.dart';
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
        topText:
            AppLocalizations.of(context).translate('want_to_provide_skill'),
        middleText:
            '${AppLocalizations.of(context).translate('add_skill')}\n${AppLocalizations.of(context).translate('specify_topic_description')}\n${AppLocalizations.of(context).translate('what_you_want_exchange')}',
        bottomText: AppLocalizations.of(context)
            .translate('wait_to_get_notified_or_actively_look'),
      ),
    );
  }
}
