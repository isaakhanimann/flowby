import 'package:flutter/material.dart';
import 'package:float/constants.dart';

class LoginInputField extends StatelessWidget {
  LoginInputField({this.setText, this.isEmail});
  final Function setText;
  final bool isEmail;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: isEmail ? TextInputType.emailAddress : null,
        obscureText: !isEmail,
        style: TextStyle(color: kDarkGreenColor),
        onChanged: setText,
        decoration: kInputDecoration.copyWith(
            hintText: isEmail ? 'Enter your email' : 'Enter your password'),
      ),
    );
  }
}

const kInputDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: kDarkGreenColor),
  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kDarkGreenColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kDarkGreenColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  filled: true,
  fillColor: kBeigeColor,
);
