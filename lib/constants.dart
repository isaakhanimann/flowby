import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: kDarkGreenColor,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kBigTitleTextStyle = TextStyle(
  fontFamily: 'MontserratRegular',
  fontSize: 45.0,
  fontWeight: FontWeight.w900,
  color: kDarkGreenColor,
);

const kUsernameTitleTextStyle = TextStyle(
  fontFamily: 'MontserratRegular',
  fontSize: 35.0,
  fontWeight: FontWeight.w900,
  color: kLoginBackgroundColor,
);

const kSkillsTitleTextStyle = TextStyle(
  fontFamily: 'MontserratRegular',
  fontSize: 30.0,
  fontWeight: FontWeight.w900,
  color: kLoginBackgroundColor,
);

const kSmallTitleTextStyle = TextStyle(
  fontFamily: 'NotoRegular',
  fontSize: 20.0,
  fontWeight: FontWeight.w400,
  color: kGrey1,
);

const kAddSkillsTextStyle = TextStyle(
  fontFamily: 'NotoRegular',
  fontSize: 18.0,
  fontWeight: FontWeight.w400,
  color: kGrey1,
);

const kLocationTextStyle = TextStyle(color: Colors.grey, fontSize: 14);
const kUsernameTextStyle = TextStyle(fontWeight: FontWeight.bold);
const kSkillTextStyle = TextStyle(color: Colors.grey, fontSize: 16);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
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

//const Color kLoginBackgroundColor = Color(0xFF0D4FF7);
const Color kLoginBackgroundColor = Color(0xFF0D4FF7);
const Color kDefaultProfilePicColor = Color(0xff00ffab);
const Color kRegistrationBackgroundColor = ffLightBlue;

const TextStyle kCupertinoScaffoldTextStyle = TextStyle(
  color: CupertinoColors.white,
  fontFamily: 'MontserratRegular',
);

const TextStyle kTabsLargeTitleTextStyle = TextStyle(
  fontFamily: 'MontserratRegular',
);

const Color kSearchBackground = Color(0xffe0e0e0);

const Color kPlaceHolderColor = Color(0xff979797);

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

const kGrey1 = Color(0xff393e46);
const kGrey2 = Color(0xff3c4245);
const kGrey3 = Color(0xff5f6769);
const kGrey4 = Color(0xff979797);
const kGrey5 = Color(0xffd7d1c9);
const kGrey6 = Color(0xffeae9e9);
