import 'package:flutter/material.dart';
import 'package:float/constants.dart';

class LoginInputField extends StatelessWidget {
  final Function setText;
  final bool isEmail;
  final String placeholder;

  LoginInputField({
    this.setText,
    this.isEmail,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: isEmail ? TextInputType.emailAddress : null,
      obscureText: !isEmail,
      onChanged: setText,
      decoration: kLoginInputFieldDecoration.copyWith(hintText: placeholder),
    );
  }
}
