import 'package:float/constants.dart';
import 'package:float/screens/choose_signup_or_login_screen.dart';
import 'package:flutter/cupertino.dart';

import 'rounded_button.dart';

class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      text: 'Sign In',
      color: kLoginBackgroundColor,
      textColor: CupertinoColors.white,
      onPressed: () {
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute<void>(
            builder: (context) {
              return ChooseSignupOrLoginScreen();
            },
          ),
        );
      },
    );
  }
}
