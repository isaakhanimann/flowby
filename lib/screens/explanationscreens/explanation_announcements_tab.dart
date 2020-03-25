import 'package:Flowby/app_localizations.dart';
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
              AppLocalizations.of(context).translate('see_announcements'),
              style: kExplanationTitleTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 60,
            ),
            Text(
              AppLocalizations.of(context)
                  .translate('add_delete_announcements'),
              style: kExplanationMiddleTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
