import 'package:flutter/cupertino.dart';
import 'package:Flowby/constants.dart';
import 'package:flutter/material.dart';

class ExplanationAnnouncementsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: double.infinity,
      color: kLightBlueColor,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text(
              'See Announcements',
              style: kExplanationTitleTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 60,
            ),
            Text(
              'Add your own announcements with the plus icon in the top right corner\nDelete your announcements by longpressing on it',
              style: kExplanationMiddleTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
