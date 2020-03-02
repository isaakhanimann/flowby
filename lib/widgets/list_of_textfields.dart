import 'package:Flowby/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:Flowby/constants.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ListOfTextfields extends StatefulWidget {
  final List<SkillOrWish> initialSkillsOrWishes;
  final Function updateKeywordsAtIndex;
  final Function updateDescriptionAtIndex;
  final Function updatePriceAtIndex;
  final Function addEmptySkillOrWish;
  final Function deleteSkillOrWishAtIndex;

  ListOfTextfields(
      {@required this.initialSkillsOrWishes,
      @required this.updateKeywordsAtIndex,
      @required this.updateDescriptionAtIndex,
      @required this.updatePriceAtIndex,
      @required this.addEmptySkillOrWish,
      @required this.deleteSkillOrWishAtIndex});

  @override
  _ListOfTextfieldsState createState() => _ListOfTextfieldsState();
}

class _ListOfTextfieldsState extends State<ListOfTextfields> {
  // whenever a controllers text is updated it updates the skill or wish in the parent
  List<TextEditingController> keywordControllers = [];
  List<TextEditingController> descriptionControllers = [];
  List<TextEditingController> priceControllers = [];
  List<FocusNode> focus = [];

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
    //controllers for extra skill
    widget.addEmptySkillOrWish();
    _addIthControllerToList(
        index: keywordControllers.length,
        initialKeywords: '',
        initialDescription: '',
        initialPrice: '');
  }

  @override
  void dispose() {
    List<TextEditingController> allControllers =
        keywordControllers + descriptionControllers + priceControllers;
    for (TextEditingController controller in allControllers) {
      controller.dispose();
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
        Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: CupertinoTextField(
                    focusNode: focus[rowNumber],
                    expands: true,
                    minLines: null,
                    maxLines: null,
                    style: kAddSkillsTextStyle,
                    maxLength: 20,
                    decoration: null,
                    textAlign: TextAlign.start,
                    placeholder: "#keywords",
                    controller: keywordControllers[rowNumber],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: CupertinoTextField(
                    focusNode: focus[rowNumber],
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    style: kAddSkillsTextStyle,
                    maxLength: 10,
                    decoration: null,
                    textAlign: TextAlign.start,
                    placeholder: "Price",
                    controller: priceControllers[rowNumber],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: GestureDetector(
                    onTap: () {
                      _deleteIthController(index: rowNumber);
                    },
                    child: Icon(Feather.x),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: CupertinoTextField(
                    focusNode: focus[rowNumber],
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    style: kAddSkillsTextStyle,
                    maxLength: 100,
                    decoration: null,
                    textAlign: TextAlign.start,
                    placeholder: "Description",
                    controller: descriptionControllers[rowNumber],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
          ],
        ),
      );
    }
    rows.add(
      Container(
        alignment: Alignment.bottomLeft,
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
    focus.add(FocusNode());
  }
}
