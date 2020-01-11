import 'dart:io';
import 'package:float/constants.dart';
import 'package:float/screens/login_screen.dart';
import 'package:float/screens/registration/registration_screen.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:video_player/video_player.dart';

class ChooseSignupOrLoginScreen extends StatefulWidget {
  static const String id = 'ChooseSignupOrLoginScreen';

  @override
  _ChooseSignupOrLoginScreenState createState() =>
      _ChooseSignupOrLoginScreenState();
}

class _ChooseSignupOrLoginScreenState extends State<ChooseSignupOrLoginScreen> {
  bool showSpinner = false;

  var _controller =
      VideoPlayerController.file(File('images/Freeflowter_Animation_home.mp4'));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.colorBurn),
          image: AssetImage("images/animated_login.gif"),
          alignment: Alignment(0.0, 0.0),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kDarkGreenColor),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  child: VideoPlayer(_controller),
                ),
                RoundedButton(
                  text: 'Sign Up',
                  color: ffDarkBlue,
                  textColor: Colors.white,
                  onPressed: () {
                    //Navigator.pushNamed(context, RegistrationScreen.id);
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => RegistrationScreen()));
                  },
                ),
                RoundedButton(
                  text: 'I already have an account',
                  color: Colors.white,
                  textColor: ffDarkBlue,
                  onPressed: () {
                    //Navigator.pushNamed(context, LoginScreen.id);
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => LoginScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
