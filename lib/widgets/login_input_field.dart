import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginInputField extends StatelessWidget {
  final bool isLast;
  final Function setText;
  final String placeholder;
  final bool isCapitalized;
  final TextInputType keyboardType;
  final bool obscureText;

  final TextEditingController controller;
  final FocusNode focusNode;
  final Function onFieldSubmitted;

  LoginInputField(
      {this.isLast,
      this.setText,
      this.placeholder,
      this.controller,
      this.focusNode,
      this.onFieldSubmitted,
      this.isCapitalized = false,
      this.keyboardType = TextInputType.text,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      maxLength: 35,
      textCapitalization:
          isCapitalized ? TextCapitalization.words : TextCapitalization.none,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      placeholder: placeholder,
      placeholderStyle: TextStyle(
        fontFamily: 'MontserratRegular',
      ),
      controller: controller,
      focusNode: focusNode,
      onSubmitted: onFieldSubmitted,
      textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: setText,
    );
  }
}
