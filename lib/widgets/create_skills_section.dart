import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/widgets/list_of_textfields.dart';
import 'package:flutter/cupertino.dart';

class CreateSkillsSection extends StatelessWidget {
  final List<SkillOrWish> initialSkills;
  final Function updateKeywordsAtIndex;
  final Function updateDescriptionAtIndex;
  final Function updatePriceAtIndex;
  final Function addEmptySkill;
  final Function deleteSkillAtIndex;

  CreateSkillsSection(
      {@required this.initialSkills,
      @required this.updateKeywordsAtIndex,
      @required this.updateDescriptionAtIndex,
      @required this.updatePriceAtIndex,
      @required this.addEmptySkill,
      @required this.deleteSkillAtIndex});

  @override
  Widget build(BuildContext context) {
    final List<String> topicSuggestions = [
      AppLocalizations.of(context).translate('skill_topic_suggestion_1'),
      AppLocalizations.of(context).translate('skill_topic_suggestion_2'),
      AppLocalizations.of(context).translate('skill_topic_suggestion_3'),
      AppLocalizations.of(context).translate('skill_topic_suggestion_4')
    ];
    final List<String> priceSuggestions = [
      AppLocalizations.of(context).translate('skill_price_suggestion_1'),
      AppLocalizations.of(context).translate('skill_price_suggestion_2'),
      AppLocalizations.of(context).translate('skill_price_suggestion_3'),
      AppLocalizations.of(context).translate('skill_price_suggestion_4'),
      AppLocalizations.of(context).translate('skill_price_suggestion_5')
    ];
    final List<String> descriptionSuggestions = [
      AppLocalizations.of(context).translate('skill_description_suggestion_1'),
      AppLocalizations.of(context).translate('skill_description_suggestion_2'),
      AppLocalizations.of(context).translate('skill_description_suggestion_3'),
      AppLocalizations.of(context).translate('skill_description_suggestion_4'),
      AppLocalizations.of(context).translate('skill_description_suggestion_5')
    ];

    return ListOfTextfields(
        initialSkillsOrWishes: initialSkills,
        updateKeywordsAtIndex: updateKeywordsAtIndex,
        updateDescriptionAtIndex: updateDescriptionAtIndex,
        updatePriceAtIndex: updatePriceAtIndex,
        addEmptySkillOrWish: addEmptySkill,
        deleteSkillOrWishAtIndex: deleteSkillAtIndex,
        topicSuggestions: topicSuggestions,
        priceSuggestions: priceSuggestions,
        descriptionSuggestions: descriptionSuggestions);
  }
}
