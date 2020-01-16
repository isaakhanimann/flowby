import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return CupertinoTextField(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      placeholder: placeholder,
      placeholderStyle: TextStyle(
        fontFamily: 'MontserratRegular',
      ),
      controller: controller,
      focusNode: focusNode,
      onSubmitted: onFieldSubmitted,
      textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
      keyboardType: isEmail ? TextInputType.emailAddress : null,
      obscureText: !isEmail,
      onChanged: setText,
    );
  }
}
