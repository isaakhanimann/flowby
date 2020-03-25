import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/constants.dart';
import 'package:Flowby/screens/login_screen.dart';
import 'package:Flowby/screens/registration/registration_screen.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:Flowby/widgets/tab_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

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
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                      RoundedButton(
                        text: AppLocalizations.of(context).translate('sign_up'),
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
                        text: AppLocalizations.of(context)
                            .translate('already_have_account'),
                        color: Colors.white,
                        textColor: kBlueButtonColor,
                        paddingInsideHorizontal: 16,
                        onPressed: () {
                          //Navigator.pushNamed(context, LoginScreen.id);
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: FlatButton(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('privacy_policy'),
                                style: kPrivacyPolicyTextStyle,
                              ),
                              onPressed: () => _launchURL(
                                  url: 'https://flowby.co/privacy-policy.pdf'),
                            ),
                          ),
                          Text(
                            '|',
                            style: kPrivacyPolicyTextStyle,
                          ),
                          Flexible(
                            child: FlatButton(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('terms_and_conditions'),
                                style: kPrivacyPolicyTextStyle,
                              ),
                              onPressed: () => _launchURL(
                                  url:
                                      'https://flowby.co/terms-and-conditions.pdf'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.canGoBack)
                TabHeader(
                  backgroundColor: Colors.transparent,
                  whiteLogo: true,
                  leftIcon: Icon(
                    Feather.chevron_left,
                    size: 30,
                  ),
                  onPressedLeft: () => Navigator.of(context).pop(),
                ),
            ]),
          ),
        ],
      ),
    );
  }
}

_launchURL({@required String url}) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
