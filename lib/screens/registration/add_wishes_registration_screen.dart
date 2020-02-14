import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/navigation_screen.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/widgets/progress_bar.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class AddWishesRegistrationScreen extends StatefulWidget {
  static const String id = 'add_whishes_registration_screen';

  final User user;

  AddWishesRegistrationScreen({this.user});

  @override
  _AddWishesRegistrationScreenState createState() =>
      _AddWishesRegistrationScreenState();
}

class _AddWishesRegistrationScreenState
    extends State<AddWishesRegistrationScreen> {
  bool showSpinner = false;

  bool _localHasWishes = true;

  List<TextEditingController> wishKeywordControllers = [];
  List<TextEditingController> wishDescriptionControllers = [];
  List<TextEditingController> wishPriceControllers = [];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Stack(children: [
              Hero(
                child: ProgressBar(progress: 1),
                transitionOnUserGestures: true,
                tag: 'progress_bar',
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Your wishes',
                            style: kUsernameTitleTextStyle,
                          ),
                          CupertinoSwitch(
                            value: _localHasWishes,
                            onChanged: (newBool) {
                              setState(() {
                                _localHasWishes = newBool;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      if (_localHasWishes)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Tell others what you would like to learn',
                              textAlign: TextAlign.start,
                              style: kRegisterHeaderTextStyle,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            _buildListOfTextFields(isSkillBuild: false),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      RoundedButton(
                        text: 'I am ready!',
                        color: kBlueButtonColor,
                        textColor: Colors.white,
                        onPressed: () {
                          _uploadUserAndNavigate(context);
                        },
                      ),
                    ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Column _buildListOfTextFields({bool isSkillBuild}) {
    if (wishKeywordControllers.length == 0) {
      setState(() {
        // Default controllers
        wishKeywordControllers.add(TextEditingController());
        wishDescriptionControllers.add(TextEditingController());
        wishPriceControllers.add(TextEditingController());
      });
    }

    List<Widget> rows = [];
    for (int rowNumber = 0;
        rowNumber < wishKeywordControllers.length;
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
                    controller: wishKeywordControllers[rowNumber],
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
                    controller: wishPriceControllers[rowNumber],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      wishKeywordControllers.removeAt(rowNumber);
                      wishDescriptionControllers.removeAt(rowNumber);
                      wishPriceControllers.removeAt(rowNumber);
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
                    placeholder: "description",
                    controller: wishDescriptionControllers[rowNumber],
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
      _addRowButton(),
    );
    return Column(
      children: rows,
    );
  }

  Widget _addRowButton() {
    return Container(
      alignment: Alignment.bottomLeft,
      child: GestureDetector(
        child: Icon(Feather.plus),
        onTap: () {
          setState(() {
            wishKeywordControllers.add(TextEditingController());
            wishDescriptionControllers.add(TextEditingController());
            wishPriceControllers.add(TextEditingController());
          });
        },
      ),
    );
  }

  Future<void> _uploadUserAndNavigate(BuildContext context) async {
    setState(() {
      showSpinner = true;
    });

    List<SkillOrWish> wishes = User.controllersToListOfSkillsOrWishes(
        keywordsControllers: wishKeywordControllers,
        descriptionControllers: wishDescriptionControllers,
        priceControllers: wishPriceControllers);

    widget.user.hasWishes = _localHasWishes;
    widget.user.wishes = wishes;
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    await cloudFirestoreService.uploadUser(user: widget.user);
    setState(() {
      showSpinner = false;
    });

    Navigator.of(context).pushNamedAndRemoveUntil(
      NavigationScreen.id,
      (Route<dynamic> route) => false,
    );
  }
}
