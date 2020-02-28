import 'package:Flowby/models/user.dart';
import 'package:Flowby/widgets/list_of_textfields.dart';
import 'package:flutter/cupertino.dart';

class CreateWishesSection extends StatelessWidget {
  final List<SkillOrWish> initialWishes;
  final Function updateKeywordsAtIndex;
  final Function updateDescriptionAtIndex;
  final Function updatePriceAtIndex;
  final Function addEmptyWish;
  final Function deleteWishAtIndex;
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
    'It\'d be great if you have already passed this course',
    'I need help understanding higher dimensional spaces',
    'Its urgent the exam is tomorrow'
  ];

  CreateWishesSection(
      {@required this.initialWishes,
      @required this.updateKeywordsAtIndex,
      @required this.updateDescriptionAtIndex,
      @required this.updatePriceAtIndex,
      @required this.addEmptyWish,
      @required this.deleteWishAtIndex});

  @override
  Widget build(BuildContext context) {
    return ListOfTextfields(
        initialSkillsOrWishes: initialWishes,
        updateKeywordsAtIndex: updateKeywordsAtIndex,
        updateDescriptionAtIndex: updateDescriptionAtIndex,
        updatePriceAtIndex: updatePriceAtIndex,
        addEmptySkillOrWish: addEmptyWish,
        deleteSkillOrWishAtIndex: deleteWishAtIndex,
        topicSuggestions: topicSuggestions,
        priceSuggestions: priceSuggestions,
        descriptionSuggestions: descriptionSuggestions);
  }
}
