import 'package:float/constants.dart';
import 'package:float/screens/registration_screen.dart';
import 'package:float/screens/login_screen.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    FirebaseConnection.autoLogin(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.colorBurn),
          image: AssetImage("images/splash_screen_background.png"),
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
                RoundedButton(
                  color: ffDarkBlue,
                  textColor: Colors.white,
                  onPressed: () {
                    //Navigator.pushNamed(context, RegistrationScreen.id);
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => RegistrationScreen()));
                  },
                  text: 'Sign Up',
                ),
                RoundedButton(
                  color: Colors.white,
                  textColor: ffDarkBlue,
                  onPressed: () {
                    //Navigator.pushNamed(context, LoginScreen.id);
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => LoginScreen()));
                  },
                  text: 'I already have an account',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
