import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../constants.dart';

class NoResults extends StatelessWidget {
  final bool isSkillSelected;

  NoResults({this.isSkillSelected});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(height: 15.0),
            Image.asset(
              'assets/images/stony_sad.png',
              height: 200,
            ),
            SizedBox(height: 15.0),
            isSkillSelected
                ? Text(
                    'There is no user with this skill... One day, it will be possible to find any skill.',
                    style: kAddSkillsTextStyle)
                : Text(
                    'There is no user with this wish... One day, it will be possible to find any wish.',
                    style: kAddSkillsTextStyle),
            SizedBox(height: 5.0),
            RoundedButton(
              text: ' Help us spread the word',
              textColor: Colors.white,
              color: ffDarkBlue,
              onPressed: () => Share.share(
                  'Flowby is a skill-sharing community where you meet people nearby you to learn new skills. The more, the merrier and the more skills. Join the adventure: https://flowby.app/'),
            ),
          ],
        ),
      ),
    );
  }
}
