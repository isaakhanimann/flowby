import 'package:flutter/material.dart';
import 'package:float/constants.dart';

class LoginInputField extends StatelessWidget {
  LoginInputField({this.setText, this.isEmail, this.placeholder});
  final Function setText;
  final bool isEmail;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: isEmail ? TextInputType.emailAddress : null,
      obscureText: !isEmail,
      onChanged: setText,
      decoration: kLoginInputFieldDecoration.copyWith(
          hintText: placeholder),
    );
  }
}
