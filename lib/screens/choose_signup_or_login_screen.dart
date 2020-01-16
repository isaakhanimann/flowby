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

  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/videos/Freeflowter_Animation_home.mp4')
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized
            _controller.play();
            _controller.setLooping(true);
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size?.width ?? 0,
              height: _controller.value.size?.height ?? 0,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
        Scaffold(
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
                  SizedBox(
                    width: 700.0,
                    height: 400.0,
                    child: null,
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
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
