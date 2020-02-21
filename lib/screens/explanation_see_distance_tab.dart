import 'package:flutter/cupertino.dart';
import 'package:Flowby/constants.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ExplanationSeeDistanceTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: CupertinoColors.activeOrange,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Feather.navigation,
              size: 50,
            ),
            SizedBox(height: 50),
            Text(
              'See how far away the other users are',
              style: kExplanationMiddleTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
