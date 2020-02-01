import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/navigation_screen.dart';
import 'package:Flowby/services/firebase_auth_service.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/widgets/progress_bar.dart';
import 'package:Flowby/widgets/rate_picker.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class AddUsernameRegistrationScreen extends StatefulWidget {
  static const String id = 'add_whishes_registration_screen';

  final User user;

  AddUsernameRegistrationScreen({this.user});

  @override
  _AddUsernameRegistrationScreenState createState() =>
      _AddUsernameRegistrationScreenState();
}

class _AddUsernameRegistrationScreenState
    extends State<AddUsernameRegistrationScreen> {
  bool showSpinner = false;

//  String _databaseHashtagWishes;
  int _databaseWishRate = 20;
  bool _localHasWishes = true;

  User _user;

  List<TextEditingController> skillKeywordControllers = [];
  List<TextEditingController> skillDescriptionControllers = [];
  List<TextEditingController> wishKeywordControllers = [];
  List<TextEditingController> wishDescriptionControllers = [];

  Column _buildListOfTextFields({bool isSkillBuild}) {
    if (isSkillBuild) {
      if (skillKeywordControllers.length == 0) {
        setState(() {
          // Default controllers
          skillKeywordControllers.add(TextEditingController());
          skillDescriptionControllers.add(TextEditingController());
        });
      }
    } else {
      if (wishKeywordControllers.length == 0) {
        setState(() {
          // Default controllers
          wishKeywordControllers.add(TextEditingController());
          wishDescriptionControllers.add(TextEditingController());
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
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: CupertinoTextField(
                expands: true,
                minLines: null,
                maxLines: null,
                style: kAddSkillsTextStyle,
                maxLength: 20,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: kBoxBorderColor),
                  ),
                ),
                textAlign: TextAlign.start,
                placeholder: "#keywords",
                controller: isSkillBuild
                    ? skillKeywordControllers[rowNumber]
                    : wishKeywordControllers[rowNumber],
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: CupertinoTextField(
                expands: true,
                maxLines: null,
                minLines: null,
                style: kAddSkillsTextStyle,
                maxLength: 100,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: kBoxBorderColor),
                  ),
                ),
                textAlign: TextAlign.start,
                placeholder: "description",
                controller: isSkillBuild
                    ? skillDescriptionControllers[rowNumber]
                    : wishDescriptionControllers[rowNumber],
              ),
            ),
            Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: GestureDetector(
                  onTap: () => setState(() {
                    wishKeywordControllers.removeAt(rowNumber);
                    wishDescriptionControllers.removeAt(rowNumber);
                  }),
                  child: Icon(Feather.x),
                ),
              ),
            ),
          ],
        ),
      );
    }

    rows.add(
      Center(
        child: RoundedButton(
          onPressed: () {
            setState(() {
              if (isSkillBuild) {
                skillKeywordControllers.add(TextEditingController());
                skillDescriptionControllers.add(TextEditingController());
              } else {
                wishKeywordControllers.add(TextEditingController());
                wishDescriptionControllers.add(TextEditingController());
              }
            });
          },
          text: "Add",
          color: kLoginBackgroundColor,
          textColor: Colors.white,
          paddingInsideHorizontal: 20,
          paddingInsideVertical: 5,
          elevation: 0,
        ),
      ),
    );
    return Column(
      children: rows,
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
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'MontserratRegular',
                                  fontSize: 22.0,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              _buildListOfTextFields(isSkillBuild: false),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'How much would you pay for someone\'s presence?',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'MontserratRegular',
                                  fontSize: 18.0,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              RatePicker(
                                initialValue: _user.skillRate ?? 20,
                                onSelected: (selectedIndex) {
                                  _databaseWishRate = selectedIndex;
                                },
                              ),
                            ],
                          ),
                        RoundedButton(
                          text: 'I am ready!',
                          color: kBlueButtonColor,
                          textColor: Colors.white,
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });

                            Map<String, String> wishes = controllersToMap(
                                keyControllers: wishKeywordControllers,
                                descriptionControllers:
                                    wishDescriptionControllers);

                            _user.hasWishes = _localHasWishes;
                            _user.wishRate = _databaseWishRate;
                            _user.wishes = wishes;

                            final cloudFirestoreService =
                                Provider.of<FirebaseCloudFirestoreService>(
                                    context,
                                    listen: false);

                            await cloudFirestoreService.uploadUser(user: _user);
                            final authService =
                                Provider.of<FirebaseAuthService>(context,
                                    listen: false);

                            /*
                            final loggedInUser = Provider.of<FirebaseUser>(
                                context,
                                listen: false);
                            */

                            authService.getCurrentUser().then((loggedInUser) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                NavigationScreen.id,
                                (Route<dynamic> route) => false,
                              );
                            });

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
