import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/services/firebase_auth_service.dart';
import 'package:float/services/firebase_storage_service.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:float/screens/registration/add_wishes_registration_screen.dart';

//TODO: change box border when the user doesn't enter an input

class AddSkillsRegistrationScreen extends StatefulWidget {
  static const String id = 'upload_picture_registration_screen';

  final String username;

  AddSkillsRegistrationScreen({this.username});

  @override
  _AddSkillsRegistrationScreenState createState() =>
      _AddSkillsRegistrationScreenState();
}

class _AddSkillsRegistrationScreenState
    extends State<AddSkillsRegistrationScreen> {
  bool showSpinner = false;

  String _username;

  @override
  Widget build(BuildContext context) {
    widget.username != null ? _username = widget.username : _username = 'error';

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
                        'Spread what you are good at',
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
                      RoundedButton(
                        text: 'Next',
                        color: ffDarkBlue,
                        textColor: Colors.white,
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });

                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute<void>(
                              builder: (context) {
                                return AddWishesRegistrationScreen();
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
                                return AddWishesRegistrationScreen();
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
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
