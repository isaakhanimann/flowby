import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/registration/add_wishes_registration_screen.dart';
import 'package:Flowby/widgets/list_of_textfields.dart';
import 'package:Flowby/widgets/progress_bar.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';

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
                            ListOfTextfields(
                                initialSkills: widget.user.skills,
                                updateKeywordsAtIndex: updateKeywordsAtIndex,
                                updateDescriptionAtIndex:
                                    updateDescriptionAtIndex,
                                updatePriceAtIndex: updatePriceAtIndex,
                                addEmptySkill: addEmptySkill),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      RoundedButton(
                        text: 'Next',
                        color: kBlueButtonColor,
                        textColor: Colors.white,
                        onPressed: () {
                          _uploadUserAndNavigate(context);
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
    );
  }

  updateKeywordsAtIndex({int index, String text}) {
    widget.user.skills[index].keywords = text;
  }

  updateDescriptionAtIndex({int index, String text}) {
    widget.user.skills[index].description = text;
  }

  updatePriceAtIndex({int index, String text}) {
    widget.user.skills[index].price = text;
  }

  addEmptySkill() {
    widget.user.skills
        .add(SkillOrWish(keywords: '', description: '', price: ''));
  }

  Future<void> _uploadUserAndNavigate(BuildContext context) async {
    setState(() {
      showSpinner = true;
    });

    widget.user.hasSkills = _localHasSkills;
    widget.user.skills.removeWhere(
        (skill) => (skill.keywords == null || skill.keywords.isEmpty));

    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    await cloudFirestoreService.uploadUser(user: widget.user);
    setState(() {
      showSpinner = false;
    });
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute<void>(
        builder: (context) {
          return AddWishesRegistrationScreen(user: widget.user);
        },
      ),
    );
  }
}
