import 'package:flutter/material.dart';
import 'package:float/constants.dart';

class LoginInputField extends StatelessWidget {
  LoginInputField({this.setText, this.isEmail});
  final Function setText;
  final bool isEmail;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: isEmail ? TextInputType.emailAddress : null,
      obscureText: !isEmail,
      onChanged: setText,
      decoration: kLoginInputFieldDecoration.copyWith(
          hintText: isEmail ? 'Enter your email' : 'Enter your password'),
    );
  }
}
