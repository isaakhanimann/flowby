import 'package:Flowby/app_localizations.dart';
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
        topText: AppLocalizations.of(context).translate('didnt_find_anyone'),
        middleText:
            '${AppLocalizations.of(context).translate('add_wish')}\n${AppLocalizations.of(context).translate('specify_the_wish_topic_description')}\n${AppLocalizations.of(context).translate('add_the_price_for_wish')}',
        bottomText:
            AppLocalizations.of(context).translate('wait_to_get_notified_wish'),
      ),
    );
  }
}
