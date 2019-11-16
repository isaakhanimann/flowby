import 'package:flutter/material.dart';

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
      decoration: kInputDecoration.copyWith(
          hintText: isEmail ? 'Enter your email' : 'Enter your password'),
    );
  }
}

const kInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
);
