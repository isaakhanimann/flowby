import 'package:Flowby/constants.dart';
import 'package:Flowby/screens/login_screen.dart';
import 'package:Flowby/screens/registration/registration_screen.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:video_player/video_player.dart';

class ChooseSigninScreen extends StatefulWidget {
  static const String id = 'ChooseSigninScreen';

  ChooseSigninScreen({this.canGoBack = false});

  final bool canGoBack;

  @override
  _ChooseSigninScreenState createState() => _ChooseSigninScreenState();
}

class _ChooseSigninScreenState extends State<ChooseSigninScreen> {
  bool showSpinner = false;

  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
        'assets/videos/Freeflowter_Animation_home.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: Stack(
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
          SafeArea(
            child: Stack(children: [
              ModalProgressHUD(
                inAsyncCall: showSpinner,
                progressIndicator: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
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
                        color: kBlueButtonColor,
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
                        textColor: kBlueButtonColor,
                        paddingInsideHorizontal: 25,
                        onPressed: () {
                          //Navigator.pushNamed(context, LoginScreen.id);
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                      ),
                      SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                ),
              ),
              if (widget.canGoBack)
                Positioned(
                  top: 0,
                  left: 0,
                  child: CupertinoButton(
                    child: Icon(
                      Feather.chevron_left,
                      size: 40,
                      color: kDefaultProfilePicColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
