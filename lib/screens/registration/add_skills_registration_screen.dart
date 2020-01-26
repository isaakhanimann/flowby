import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/registration/add_wishes_registration_screen.dart';
import 'package:Flowby/widgets/progress_bar.dart';
import 'package:Flowby/widgets/rate_picker.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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

//  String _databaseHashtagSkills;
  int _databaseSkillRate = 20;
  bool _localHasSkills = true;

  User _user;

  @override
  Widget build(BuildContext context) {
    widget.user != null
        ? _user = widget.user
        : print('Why da fuck is User == NULL?!');

    print(_user);
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
          valueColor: AlwaysStoppedAnimation<Color>(kDarkGreenColor),
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
                ProgressBar(progress: 0.75),
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
                              style: kMiddleTitleTextStyle,
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
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'MontserratRegular',
                                  fontSize: 22.0,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              CupertinoTextField(
                                style: TextStyle(color: kGrey3, fontSize: 20),
                                //maxLength: 20,
                                //maxLines: 1,
                                placeholder: 'e.g. #piano #salsa #algebra',
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(color: kLightGrey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'How valuable is your presence? ',
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
                                  setState(() {
                                    _databaseSkillRate = selectedIndex;
                                  });
                                },
                              ),
                            ],
                          ),
                        RoundedButton(
                          text: 'Next',
                          color: ffDarkBlue,
                          textColor: Colors.white,
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });

                            _user.hasSkills = _localHasSkills;
//                            _user.skillHashtags = _databaseHashtagSkills;
                            _user.skillRate = _databaseSkillRate;

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
