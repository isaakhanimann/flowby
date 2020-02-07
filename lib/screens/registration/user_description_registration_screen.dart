import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/registration/add_languages_registration_screen.dart';
import 'package:Flowby/widgets/progress_bar.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class UserDescriptionRegistrationScreen extends StatefulWidget {
  static const String id = 'user_description_registration_screen';

  final User user;

  UserDescriptionRegistrationScreen({this.user});

  @override
  _UserDescriptionRegistrationScreenState createState() =>
      _UserDescriptionRegistrationScreenState();
}

class _UserDescriptionRegistrationScreenState
    extends State<UserDescriptionRegistrationScreen> {
  bool showSpinner = false;

  String _bio;
  User _user;

  @override
  Widget build(BuildContext context) {
    widget.user != null ? _user = widget.user : print('error, no user found');

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
                  child: ProgressBar(progress: 0.4),
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
                          height: 10.0,
                        ),
                        Text(
                          'Let the others know who you are',
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
                            _bio = value;
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Your biography...',
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle:
                                TextStyle(fontFamily: 'MontserratRegular'),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 45.0, horizontal: 30.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                        RoundedButton(
                          text: 'Next',
                          color: kBlueButtonColor,
                          textColor: Colors.white,
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });

                            _user.bio = _bio;

                            Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute<void>(
                                builder: (context) {
                                  return AddLanguagesRegistrationScreen(
                                      user: _user);
                                },
                              ),
                            );

                            setState(() {
                              showSpinner = false;
                            });
                          },
                        ),
                        Text(
                          'We love real people with real stories.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratRegular',
                            fontSize: 22.0,
                          ),
                        ),
                        /*Container(
                          height: 350.0,
                          width: 350.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.white, BlendMode.colorBurn),
                              image: AssetImage(
                                  "assets/images/Freeflowter_Stony.png"),
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
