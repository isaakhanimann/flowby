import 'package:Flowby/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:Flowby/constants.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ListOfTextfields extends StatefulWidget {
  List<SkillOrWish> initialSkills;
  Function updateKeywordsAtIndex;
  Function updateDescriptionAtIndex;
  Function updatePriceAtIndex;
  Function addEmptySkill;

  ListOfTextfields(
      {@required this.initialSkills,
      @required this.updateKeywordsAtIndex,
      @required this.updateDescriptionAtIndex,
      @required this.updatePriceAtIndex,
      @required this.addEmptySkill});

  @override
  _ListOfTextfieldsState createState() => _ListOfTextfieldsState();
}

class _ListOfTextfieldsState extends State<ListOfTextfields> {
  // whenever a controllers text is updated it updates the skill in the parent
  List<TextEditingController> keywordControllers = [];
  List<TextEditingController> descriptionControllers = [];
  List<TextEditingController> priceControllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.initialSkills.length; i++) {
      SkillOrWish skill = widget.initialSkills[i];
      _addIthControllerToList(
          index: i,
          initialKeywords: skill.keywords,
          initialDescription: skill.description,
          initialPrice: skill.price);
    }
    //controllers for extra skill
    widget.addEmptySkill();
    _addIthControllerToList(
        index: keywordControllers.length,
        initialKeywords: '',
        initialDescription: '',
        initialPrice: '');
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
                    expands: true,
                    minLines: null,
                    maxLines: null,
                    style: kAddSkillsTextStyle,
                    maxLength: 20,
                    decoration: null,
                    textAlign: TextAlign.start,
                    placeholder: "e.g. #english",
                    controller: keywordControllers[rowNumber],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: CupertinoTextField(
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    style: kAddSkillsTextStyle,
                    maxLength: 10,
                    decoration: null,
                    textAlign: TextAlign.start,
                    placeholder: "e.g. free",
                    controller: priceControllers[rowNumber],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      keywordControllers.removeAt(rowNumber);
                      descriptionControllers.removeAt(rowNumber);
                      priceControllers.removeAt(rowNumber);
                    }),
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
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    style: kAddSkillsTextStyle,
                    maxLength: 100,
                    decoration: null,
                    textAlign: TextAlign.start,
                    placeholder: "e.g. native",
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
            widget.addEmptySkill();
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
  }
}
