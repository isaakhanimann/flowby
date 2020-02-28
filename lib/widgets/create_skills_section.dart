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
  final List<String> topicSuggestions = [
    'english',
    'statistics',
    'linear algebra',
    'math',
    'german',
    'skating'
  ];
  final List<String> priceSuggestions = [
    '30.-/h',
    '70.-/d',
    'free',
    '50 CHF',
    'coffee'
  ];
  final List<String> descriptionSuggestions = [
    'I have half a year of experience'
  ];

  CreateSkillsSection(
      {@required this.initialSkills,
      @required this.updateKeywordsAtIndex,
      @required this.updateDescriptionAtIndex,
      @required this.updatePriceAtIndex,
      @required this.addEmptySkill,
      @required this.deleteSkillAtIndex});

  @override
  Widget build(BuildContext context) {
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
