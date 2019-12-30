import 'package:flutter/material.dart';

import 'package:float/services/firebase_connection.dart';
import 'package:float/constants.dart';
import 'package:float/widgets/login_input_field.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:float/widgets/alert.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String id = 'reset_password_screen';

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String email;

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
          image: AssetImage("images/Freeflowter_Stony_Fond1.png"),
          alignment: Alignment(0.0, 0.0),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reset password'),
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
                SizedBox(
                  height: 48.0,
                ),
                LoginInputField(
                  isLast: false,
                  isEmail: true,
                  placeholder: 'Email Address',
                  setText: (value) {
                    email = value;
                  },
                ),
                RoundedButton(
                    color: kDarkGreenColor,
                    onPressed: () async {
                      showAlert(
                          context: context,
                          title: "You've got mail",
                          description:
                              "We sent you an email. Tap the link in that email to reset your password.");
                      await FirebaseConnection.resetPassword(email: email);
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
