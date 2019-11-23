import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: kDarkGreenColor,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kBigTitleTextStyle = TextStyle(
  fontSize: 45.0,
  fontWeight: FontWeight.w900,
  color: kDarkGreenColor,
  letterSpacing: 3.0,
);

const kMiddleTitleTextStyle = TextStyle(
  fontSize: 35.0,
  fontWeight: FontWeight.w900,
  color: kDarkGreenColor,
  letterSpacing: 3.0,
);

const kSmallTitleTextStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w500,
  color: kDarkGreenColor,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: kDarkGreenColor, width: 2.0),
  ),
);

const kBeigeColor = Color(0xFFFCF9EC);
const kLightGreenColor = Color(0xFFB0F4E6);
const kMiddleGreenColor = Color(0xFF67EACA);
const kDarkGreenColor = Color(0xFF12D3CF);
