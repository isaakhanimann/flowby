import 'package:flutter/material.dart';
import 'package:float/constants.dart';

class LoginInputField extends StatelessWidget {
  final bool isLast;
  final Function setText;
  final bool isEmail;
  final String placeholder;

  final TextEditingController controller;
  final FocusNode focusNode;
  final Function onFieldSubmitted;

  LoginInputField({
    this.isLast,
    this.setText,
    this.isEmail,
    this.placeholder,
    this.controller,
    this.focusNode,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
      keyboardType: isEmail ? TextInputType.emailAddress : null,
      obscureText: !isEmail,
      onChanged: setText,
      decoration: ffLoginInputFieldDecoration.copyWith(hintText: placeholder),
    );
  }
}
