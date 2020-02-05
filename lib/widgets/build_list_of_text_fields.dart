// TODO: Use Listenable Class (similar to Provider) to refactor the BuildList of TextFields
// https://stackoverflow.com/questions/50430273/how-to-set-state-from-another-widget
// https://api.flutter.dev/flutter/foundation/Listenable-class.html

import 'package:Flowby/models/user.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class BuildListOfTextFields extends StatefulWidget {
  final User user;
  final bool isSkillBuild;

  BuildListOfTextFields({@required this.user, @required this.isSkillBuild});

  @override
  _BuildListOfTextFieldsState createState() => _BuildListOfTextFieldsState();
}

class _BuildListOfTextFieldsState extends State<BuildListOfTextFields> {
  List<TextEditingController> skillKeywordControllers = [];
  List<TextEditingController> skillDescriptionControllers = [];
  List<TextEditingController> skillPriceControllers = [];

  List<TextEditingController> wishKeywordControllers = [];
  List<TextEditingController> wishDescriptionControllers = [];
  List<TextEditingController> wishPriceControllers = [];

  void _getUser(BuildContext context) async {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    String uid = widget.user.uid;
    User user = await cloudFirestoreService.getUser(uid: uid);
    //also fill the temps in case the user presses save and the messageboxes are filled

    setState(() {
      user.skillz?.forEach((SkillOrWish skillOrWish) {
        skillKeywordControllers
            .add(TextEditingController(text: skillOrWish.keywords));
        skillDescriptionControllers
            .add(TextEditingController(text: skillOrWish.description));
        skillPriceControllers
            .add(TextEditingController(text: skillOrWish.price));
      });
      //controllers for extra skill
      skillKeywordControllers.add(TextEditingController());
      skillDescriptionControllers.add(TextEditingController());
      skillPriceControllers.add(TextEditingController());

      user.wishez?.forEach((SkillOrWish skillOrWish) {
        wishKeywordControllers
            .add(TextEditingController(text: skillOrWish.keywords));
        wishDescriptionControllers
            .add(TextEditingController(text: skillOrWish.description));
        wishPriceControllers
            .add(TextEditingController(text: skillOrWish.price));
      });
      wishKeywordControllers.add(TextEditingController());
      wishDescriptionControllers.add(TextEditingController());
      wishPriceControllers.add(TextEditingController());
    });
  }

  Widget _addRowButton(isSkillBuild) {
    return Container(
      alignment: Alignment.bottomLeft,
      child: GestureDetector(
        child: Icon(Feather.plus),
        onTap: () {
          setState(() {
            if (isSkillBuild) {
              skillKeywordControllers.add(TextEditingController());
              skillDescriptionControllers.add(TextEditingController());
              skillPriceControllers.add(TextEditingController());
            } else {
              wishKeywordControllers.add(TextEditingController());
              wishDescriptionControllers.add(TextEditingController());
              wishPriceControllers.add(TextEditingController());
            }
          });
        },
      ),
    );
  }

  Column _buildListOfRows({bool isSkillBuild}) {
    List<Widget> rows = [];
    for (int rowNumber = 0;
        rowNumber <
            (isSkillBuild
                ? skillKeywordControllers.length
                : wishKeywordControllers.length);
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
                    placeholder: "#keywords",
                    controller: isSkillBuild
                        ? skillKeywordControllers[rowNumber]
                        : wishKeywordControllers[rowNumber],
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
                    placeholder: "price",
                    controller: isSkillBuild
                        ? skillPriceControllers[rowNumber]
                        : wishPriceControllers[rowNumber],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      if (isSkillBuild) {
                        skillKeywordControllers.removeAt(rowNumber);
                        skillDescriptionControllers.removeAt(rowNumber);
                        skillPriceControllers.removeAt(rowNumber);
                      } else {
                        wishKeywordControllers.removeAt(rowNumber);
                        wishDescriptionControllers.removeAt(rowNumber);
                        wishPriceControllers.removeAt(rowNumber);
                      }
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
                    style: kAddSkillsTextStyle,
                    maxLength: 100,
                    decoration: null,
                    textAlign: TextAlign.start,
                    placeholder: "description",
                    controller: isSkillBuild
                        ? skillDescriptionControllers[rowNumber]
                        : wishDescriptionControllers[rowNumber],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
          ],
        ),
      );
    }

    rows.add(_addRowButton(isSkillBuild));
    return Column(
      children: rows,
    );
  }




  @override
  void initState() {
    super.initState();
    //this is an asynchronous method
    _getUser(context);

  }

  void dispose() {
    List<TextEditingController> allControllers = skillKeywordControllers +
        skillDescriptionControllers +
        wishKeywordControllers +
        wishDescriptionControllers;
    for (TextEditingController controller in allControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildListOfRows(isSkillBuild: widget.isSkillBuild);
  }
}
