import 'package:float/constants.dart';
import 'package:float/services/firebase_auth_service.dart';
import 'package:float/widgets/alert.dart';
import 'package:float/widgets/login_input_field.dart';
import 'package:float/widgets/rounded_button.dart';
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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.colorBurn),
          image: AssetImage("images/Freeflowter_Stony_Fond1.png"),
          alignment: Alignment(0.0, 0.0),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Reset password',
            style: TextStyle(fontFamily: 'MontserratRegular'),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        backgroundColor: Color(0xFF0D4FF7),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
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
                      final authService = Provider.of<FirebaseAuthService>(
                          context,
                          listen: false);
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
      ),
    );
  }
}
