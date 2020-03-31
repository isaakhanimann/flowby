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
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 10,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                AppLocalizations.of(context).translate('see_announcements'),
                style: kExplanationTitleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                AppLocalizations.of(context)
                    .translate('add_delete_announcements'),
                style: kExplanationMiddleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
