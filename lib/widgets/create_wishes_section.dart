import 'package:Flowby/app_localizations.dart';
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

  CreateWishesSection(
      {@required this.initialWishes,
      @required this.updateKeywordsAtIndex,
      @required this.updateDescriptionAtIndex,
      @required this.updatePriceAtIndex,
      @required this.addEmptyWish,
      @required this.deleteWishAtIndex});

  @override
  Widget build(BuildContext context) {
    final List<String> topicSuggestions = [
      AppLocalizations.of(context).translate('wish_topic_suggestion_1'),
      AppLocalizations.of(context).translate('wish_topic_suggestion_2'),
      AppLocalizations.of(context).translate('wish_topic_suggestion_3'),
      AppLocalizations.of(context).translate('wish_topic_suggestion_4')
    ];
    final List<String> priceSuggestions = [
      AppLocalizations.of(context).translate('wish_price_suggestion_1'),
      AppLocalizations.of(context).translate('wish_price_suggestion_2'),
      AppLocalizations.of(context).translate('wish_price_suggestion_3'),
      AppLocalizations.of(context).translate('wish_price_suggestion_4'),
      AppLocalizations.of(context).translate('wish_price_suggestion_5'),
    ];
    final List<String> descriptionSuggestions = [
      AppLocalizations.of(context).translate('wish_description_suggestion_1'),
      AppLocalizations.of(context).translate('wish_description_suggestion_2'),
      AppLocalizations.of(context).translate('wish_description_suggestion_3'),
      AppLocalizations.of(context).translate('wish_description_suggestion_4')
    ];

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
