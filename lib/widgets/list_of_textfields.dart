import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:Flowby/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_typeahead/cupertino_flutter_typeahead.dart';

class ListOfTextfields extends StatefulWidget {
  final List<SkillOrWish> initialSkillsOrWishes;
  final Function updateKeywordsAtIndex;
  final Function updateDescriptionAtIndex;
  final Function updatePriceAtIndex;
  final Function addEmptySkillOrWish;
  final Function deleteSkillOrWishAtIndex;
  final List<String> topicSuggestions;
  final List<String> priceSuggestions;
  final List<String> descriptionSuggestions;

  ListOfTextfields(
      {@required this.initialSkillsOrWishes,
      @required this.updateKeywordsAtIndex,
      @required this.updateDescriptionAtIndex,
      @required this.updatePriceAtIndex,
      @required this.addEmptySkillOrWish,
      @required this.deleteSkillOrWishAtIndex,
      @required this.topicSuggestions,
      @required this.priceSuggestions,
      @required this.descriptionSuggestions});

  @override
  _ListOfTextfieldsState createState() => _ListOfTextfieldsState();
}

class _ListOfTextfieldsState extends State<ListOfTextfields> {
  // whenever a controllers text is updated it updates the skill or wish in the parent
  List<TextEditingController> keywordControllers = [];
  List<TextEditingController> descriptionControllers = [];
  List<TextEditingController> priceControllers = [];
  List<Map<String, FocusNode>> focusNodes = [];
  int indexWithFocus = -1;
  FocusNode currentFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialSkillsOrWishes != null) {
      for (int i = 0; i < widget.initialSkillsOrWishes.length; i++) {
        SkillOrWish skillOrWish = widget.initialSkillsOrWishes[i];
        _addIthControllerToList(
            index: i,
            initialKeywords: skillOrWish.keywords,
            initialDescription: skillOrWish.description,
            initialPrice: skillOrWish.price);
      }
    }
  }

  @override
  void dispose() {
    // dispose all controllers
    List<TextEditingController> allControllers =
        keywordControllers + descriptionControllers + priceControllers;
    for (TextEditingController controller in allControllers) {
      controller.dispose();
    }
    // dispose all focus nodes
    for (Map<String, FocusNode> map in focusNodes) {
      map.forEach((k, v) => v.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];
    for (int rowNumber = 0;
        rowNumber < keywordControllers.length;
        rowNumber++) {
      rows.add(
        Card(
          elevation: 0,
          color: kSecondCardBackgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              children: <Widget>[
                InputFieldWithSuggestions(
                  suggestions: widget.topicSuggestions,
                  maxLength: 20,
                  controller: keywordControllers[rowNumber],
                  placeholder: AppLocalizations.of(context).translate('topic'),
                  capitalization: TextCapitalization.words,
                  focus: focusNodes[rowNumber]['keywords'],
                  style: kAddSkillsTopicTextStyle,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: InputFieldWithSuggestions(
                        maxLength: 100,
                        controller: descriptionControllers[rowNumber],
                        suggestions: widget.descriptionSuggestions,
                        placeholder: AppLocalizations.of(context)
                            .translate('description'),
                        capitalization: TextCapitalization.sentences,
                        focus: focusNodes[rowNumber]['description'],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: indexWithFocus == rowNumber
                          ? GestureDetector(
                              onTap: () {
                                _deleteIthController(index: rowNumber);
                              },
                              child: Icon(Feather.x),
                            )
                          : Container(),
                    ),
                  ],
                ),
                InputFieldWithSuggestions(
                  maxLength: 10,
                  controller: priceControllers[rowNumber],
                  suggestions: widget.priceSuggestions,
                  placeholder: AppLocalizations.of(context).translate('price'),
                  focus: focusNodes[rowNumber]['price'],
                ),
              ],
            ),
          ),
        ),
      );
    }
    rows.add(
      Container(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          child: Icon(Feather.plus),
          onTap: () {
            widget.addEmptySkillOrWish();
            setState(() {
              _addIthControllerToList(
                  index: keywordControllers.length,
                  initialKeywords: '',
                  initialDescription: '',
                  initialPrice: '');
            });
          },
        ),
      ),
    );
    return Column(
      children: rows,
    );
  }

  _deleteIthController({int index}) {
    setState(() {
      keywordControllers.removeAt(index);
      descriptionControllers.removeAt(index);
      priceControllers.removeAt(index);
      focusNodes.removeAt(index);
    });
    widget.deleteSkillOrWishAtIndex(index: index);
  }

  _addIthControllerToList(
      {int index,
      String initialKeywords,
      String initialDescription,
      String initialPrice}) {
    // keywords
    TextEditingController keywordController =
        TextEditingController(text: initialKeywords);
    keywordController.addListener(() {
      widget.updateKeywordsAtIndex(index: index, text: keywordController.text);
    });
    keywordControllers.add(keywordController);
    // description
    TextEditingController descriptionController =
        TextEditingController(text: initialDescription);
    descriptionController.addListener(() {
      widget.updateDescriptionAtIndex(
          index: index, text: descriptionController.text);
    });
    descriptionControllers.add(descriptionController);
    // price
    TextEditingController priceController =
        TextEditingController(text: initialPrice);
    priceController.addListener(() {
      widget.updatePriceAtIndex(index: index, text: priceController.text);
    });
    priceControllers.add(priceController);
    // focus
    Map<String, FocusNode> map = {
      'keywords': FocusNode(),
      'description': FocusNode(),
      'price': FocusNode(),
    };
    map.forEach((k, v) {
      v.addListener(() {
        if (v.hasFocus)
          setState(() {
            currentFocus = v;
            indexWithFocus = index;
          });
        else if (!v.hasFocus && v == currentFocus)
          setState(() {
            indexWithFocus = -1;
          });
      });
    });
    focusNodes.add(map);
  }
}

class InputFieldWithSuggestions extends StatelessWidget {
  final int maxLength;
  final TextEditingController controller;
  final List<String> suggestions;
  final String placeholder;
  final TextCapitalization capitalization;
  final FocusNode focus;
  final TextStyle style;

  InputFieldWithSuggestions(
      {@required this.maxLength,
      @required this.controller,
      @required this.suggestions,
      @required this.placeholder,
      this.capitalization = TextCapitalization.none,
      this.focus,
      this.style = kAddSkillsTextStyle});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return CupertinoTypeAheadField(
        textFieldConfiguration: CupertinoTextFieldConfiguration(
          minLines: null,
          maxLines: null,
          style: style,
          maxLength: maxLength,
          decoration: null,
          textCapitalization: capitalization,
          textAlign: TextAlign.start,
          placeholder: placeholder,
          controller: controller,
          focusNode: focus,
        ),
        suggestionsBoxDecoration: CupertinoSuggestionsBoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          constraints: BoxConstraints(maxWidth: constraints.maxWidth - 34),
        ),
        getImmediateSuggestions: true,
        hideOnEmpty: true,
        animationDuration: const Duration(microseconds: 0),
        suggestionsCallback: _getSuggestions,
        itemBuilder: (context, suggestion) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              suggestion,
            ),
          );
        },
        onSuggestionSelected: (String tappedSuggestion) {
          controller.text = tappedSuggestion;
        },
      );
    });
  }

  List<String> _getSuggestions(String pattern) {
    List<String> suggestionResults = suggestions
        .where((suggestion) =>
            suggestion.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
    return suggestionResults;
  }
}
