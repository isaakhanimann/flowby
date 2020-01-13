import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:float/constants.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:float/widgets/rate_picker.dart';
import 'package:float/models/user.dart';

import 'package:float/screens/registration/add_wishes_registration_screen.dart';

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

  String _databaseHashtagSkills;
  int _databaseSkillRate;
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
          image: AssetImage("images/Freeflowter_Stony.png"),
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Share what you are good at',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'MontserratRegular',
                          fontSize: 22.0,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          _databaseHashtagSkills = value;
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Your skills (e.g. #guillaumetell)',
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: TextStyle(fontFamily: 'MontserratRegular'),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 30.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'How valuable is your presence? ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'MontserratRegular',
                          fontSize: 18.0,
                        ),
                      ),
                      RatePicker(
                        initialValue: _databaseSkillRate ?? 20,
                        onSelected: (selectedIndex) {
                          _databaseSkillRate = selectedIndex;
                        },
                      ),
                      RoundedButton(
                        text: 'Next',
                        color: ffDarkBlue,
                        textColor: Colors.white,
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });

                          _user.skillHashtags = _databaseHashtagSkills;
                          _user.skillRate = _databaseSkillRate;

                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute<void>(
                              builder: (context) {
                                return AddWishesRegistrationScreen(user: _user);
                              },
                            ),
                          );

                          setState(() {
                            showSpinner = false;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute<void>(
                              builder: (context) {
                                return AddWishesRegistrationScreen(user: _user);
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Skip this step',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratRegular',
                            fontSize: 16.0,
                          ),
                        ),
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
            ),
          ),
        ),
      ),
    );
  }
}
