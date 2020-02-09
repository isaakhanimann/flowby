import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/registration/add_wishes_registration_screen.dart';
import 'package:Flowby/widgets/build_list_of_text_fields.dart';
import 'package:Flowby/widgets/progress_bar.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AddSkillsRegistrationScreen extends StatefulWidget {
  static const String id = 'add_skills_registration_screen';

  final User user;

  AddSkillsRegistrationScreen({this.user});

  @override
  _AddSkillsRegistrationScreenState createState() =>
      _AddSkillsRegistrationScreenState();
}

class _AddSkillsRegistrationScreenState
    extends State<AddSkillsRegistrationScreen> {
  bool showSpinner = false;

  bool _localHasSkills = true;

  User _user;

  List<TextEditingController> skillKeywordControllers = [];
  List<TextEditingController> skillDescriptionControllers = [];
  List<TextEditingController> skillPriceControllers = [];

  List<TextEditingController> wishKeywordControllers = [];
  List<TextEditingController> wishDescriptionControllers = [];
  List<TextEditingController> wishPriceControllers = [];

  void _setLanguagesInSkills(User user) async {
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

      showSpinner = false;
    });
  }

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

  @override
  void initState() {
    super.initState();
    //this is an asynchronous method
    widget.user != null
        ? _user = widget.user
        : print('Why da fuck is User == NULL?!');
  }

  @override
  Widget build(BuildContext context) {
    //print(_user);
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
            /*appBar: AppBar(
              title: Text('Upload a picture'),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),*/
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Stack(children: [
                Hero(
                  child: ProgressBar(progress: 0.8),
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
                              'Your skills',
                              style: kUsernameTitleTextStyle,
                            ),
                            CupertinoSwitch(
                              value: _localHasSkills,
                              onChanged: (newBool) {
                                setState(() {
                                  _localHasSkills = newBool;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        if (_localHasSkills)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Share what you are good at',
                                textAlign: TextAlign.start,
                                style: kRegisterHeaderTextStyle,
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

                            _user.hasSkills = _localHasSkills;
                            _user.skillz = skillz;

                            print(_user);

                            Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute<void>(
                                builder: (context) {
                                  return AddWishesRegistrationScreen(
                                      user: _user);
                                },
                              ),
                            );

                            setState(() {
                              showSpinner = false;
                            });
                          },
                        ),
                        Container(
                          height: MediaQuery.of(context).size.width * 0.75,
                          width: MediaQuery.of(context).size.width * 0.75,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.white, BlendMode.colorBurn),
                              image: AssetImage("assets/images/flowby.png"),
                              alignment: Alignment(0.0, 0.0),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
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
