import 'package:flutter/material.dart';
import 'package:float/constants.dart';

class LoginInputField extends StatelessWidget {
  final bool isLast;
  final Function setText;
  final bool isEmail;
  final String placeholder;

  LoginInputField({
    this.isLast,
    this.setText,
    this.isEmail,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
      keyboardType: isEmail ? TextInputType.emailAddress : null,
      obscureText: !isEmail,
      onChanged: setText,
      decoration: kLoginInputFieldDecoration.copyWith(hintText: placeholder),
    );
  }
}
