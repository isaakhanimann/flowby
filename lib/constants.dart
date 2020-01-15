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
);

const kMiddleTitleTextStyle = TextStyle(
  fontSize: 35.0,
  fontWeight: FontWeight.w900,
  color: kDarkGreenColor,
);

const kSmallTitleTextStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w500,
  color: kDarkGreenColor,
);

const kLocationTextStyle = TextStyle(color: Colors.grey, fontSize: 14);
const kUsernameTextStyle = TextStyle(fontWeight: FontWeight.bold);
const kSkillTextStyle = TextStyle(color: Colors.grey, fontSize: 16);

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

const kLoginInputFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(30.0),
    ),
  ),
);

const ffLoginInputFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  hintStyle: TextStyle(fontFamily: 'MontserratRegular'),
  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(5.0),
    ),
  ),
);

const TextStyle kSearchText = TextStyle(
  color: Color.fromRGBO(0, 0, 0, 1),
  fontSize: 14,
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.normal,
);

const Color kSearchBackground = Color(0xffe0e0e0);

const Color kSearchCursorColor = Color.fromRGBO(0, 122, 255, 1);

const Color kSearchIconColor = Color.fromRGBO(128, 128, 128, 1);

const kBeigeColor = Color(0xFFFCF9EC);
const kLightGreenColor = Color(0xFFB0F4E6);
const kMiddleGreenColor = Color(0xFF67EACA);
const kDarkGreenColor = Color(0xFF12D3CF);

const kBrightGreen = Color(0xff08ffc8);
const kAlmostWhite = Color(0xFFfff7f7);
const kLightGrey = Color(0xFFdadada);
const kDarkBlue = Color(0xFF204969);

const kVeryLightGrey = Color(0xFFf6f6f6);
const kLightGrey2 = Color(0xFFf4f4f4);

const ffDarkBlue = Color(0xFF294FED);
const ffMiddleBlue = Color(0xFF2862F7);
const ffLightBlue = Color(0xff65C4EA);
