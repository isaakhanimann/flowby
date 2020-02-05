import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/registration/add_skills_registration_screen.dart';
import 'package:Flowby/widgets/progress_bar.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AddLanguagesRegistrationScreen extends StatefulWidget {
  static const String id = 'add_skills_registration_screen';

  final User user;

  AddLanguagesRegistrationScreen({this.user});

  @override
  _AddLanguagesRegistrationScreenState createState() =>
      _AddLanguagesRegistrationScreenState();
}

class _AddLanguagesRegistrationScreenState
    extends State<AddLanguagesRegistrationScreen> {
  bool showSpinner = false;

  User _user;

  List<TextEditingController> skillKeywordControllers = [];
  List<TextEditingController> skillDescriptionControllers = [];
  List<TextEditingController> skillPriceControllers = [];
  List<TextEditingController> wishKeywordControllers = [];
  List<TextEditingController> wishDescriptionControllers = [];
  List<TextEditingController> wishPriceControllers = [];

  Column _buildListOfTextFields({bool isSkillBuild}) {
    if (isSkillBuild) {
      if (skillKeywordControllers.length == 0) {
        setState(() {
          // Default controllers
          skillKeywordControllers.add(TextEditingController());
          skillDescriptionControllers.add(TextEditingController());
          skillPriceControllers.add(TextEditingController());
        });
      }
    } else {
      if (wishKeywordControllers.length == 0) {
        setState(() {
          // Default controllers
          skillKeywordControllers.add(TextEditingController());
          skillDescriptionControllers.add(TextEditingController());
          skillPriceControllers.add(TextEditingController());
        });
      }
    }

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

    rows.add(
      _addRowButton(isSkillBuild),
    );
    return Column(
      children: rows,
    );
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

  Map<String, String> controllersToMap(
      {List<TextEditingController> keyControllers,
      List<TextEditingController> descriptionControllers}) {
    Map<String, String> map = Map();
    for (int i = 0; i < keyControllers.length; i++) {
      String keyword = keyControllers[i].text;
      if (keyword != null && keyword.isNotEmpty) {
        if (!map.containsKey(keyword)) {
          map[keyword] = descriptionControllers[i].text ?? '';
        }
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    widget.user != null
        ? _user = widget.user
        : print('Why da fuck is User == NULL?!');

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.colorBurn),
          image: AssetImage("assets/images/Freeflowter_Stony.png"),
          alignment: Alignment(0.0, 0.0),
          fit: BoxFit.cover,
        ),
      ),
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Stack(children: [
                Hero(
                  child: ProgressBar(progress: 0.6),
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
                        Text(
                          'Your languages',
                          style: kUsernameTitleTextStyle,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Share your culture or meet for a tandem',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'MontserratRegular',
                                fontSize: 22.0,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            _buildListOfTextFields(isSkillBuild: true),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                        RoundedButton(
                          text: 'Next',
                          color: kBlueButtonColor,
                          textColor: Colors.white,
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });

                            List<SkillOrWish> skillz =
                                User.controllersToListOfSkillsOrWishes(
                                    keywordsControllers:
                                        skillKeywordControllers,
                                    descriptionControllers:
                                        skillDescriptionControllers,
                                    priceControllers: skillPriceControllers);

                            _user.skillz = skillz;

                            print(_user);

                            Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute<void>(
                                builder: (context) {
                                  return AddSkillsRegistrationScreen(
                                      user: _user);
                                },
                              ),
                            );

                            setState(() {
                              showSpinner = false;
                            });
                          },
                        ),
                        /*
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'We all have at least a valuable skill',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratRegular',
                            fontSize: 22.0,
                          ),
                        ),
                        Container(
                          height: 350.0,
                          width: 350.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.white, BlendMode.colorBurn),
                              image: AssetImage("images/Freeflowter_Stony.png"),
                              alignment: Alignment(0.0, 0.0),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),*/
                      ]),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}