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
    'german',
    'statistics',
    'linear algebra',
    'math',
    'skating'
  ];
  final List<String> priceSuggestions = [
    '30.-/h',
    '70.-/d',
    '50 CHF',
    'free',
    'coffee'
  ];
  final List<String> descriptionSuggestions = [
    'I need help understanding how an action potential gets triggered',
    'Its urgent the exam is tomorrow',
    'It\'d be great if you have already passed this course',
    'I\'m looking for a partner for my dance class'
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
