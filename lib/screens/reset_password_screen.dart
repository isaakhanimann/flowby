import 'package:float/constants.dart';
import 'package:float/services/firebase_auth_service.dart';
import 'package:float/widgets/alert.dart';
import 'package:float/widgets/login_input_field.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String id = 'reset_password_screen';

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String email;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        border: null,
        leading: CupertinoButton(
          child: Icon(CupertinoIcons.back, color: CupertinoColors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        middle: Text(
          'Reset password',
          style: TextStyle(color: CupertinoColors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: kLoginBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 48.0,
              ),
              LoginInputField(
                isLast: false,
                isEmail: true,
                placeholder: 'Email address',
                setText: (value) {
                  email = value;
                },
              ),
              RoundedButton(
                  color: ffDarkBlue,
                  textColor: Colors.white,
                  onPressed: () async {
                    final authService =
                        Provider.of<FirebaseAuthService>(context, listen: false);
                    showAlert(
                        context: context,
                        title: "You've got mail",
                        description:
                            "We sent you an email. Tap the link in that email to reset your password.");
                    await authService.resetPassword(email: email);
                  },
                  text: 'Send'),
            ],
          ),
        ),
      ),
    );
  }
}
