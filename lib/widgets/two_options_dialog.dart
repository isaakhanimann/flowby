import 'package:Flowby/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'custom_dialog.dart';
import 'package:Flowby/constants.dart';

class TwoOptionsDialog extends StatelessWidget {
  final String title;
  final String text;
  final String rightActionText;
  final Color rightActionColor;
  final Function rightAction;

  TwoOptionsDialog({
    @required this.title,
    @required this.text,
    @required this.rightActionText,
    @required this.rightAction,
    this.rightActionColor = kDefaultProfilePicColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: kDialogTitleTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'MuliRegular',
                color: kTextFieldTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CupertinoButton(
                  padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Text(
                    AppLocalizations.of(context).translate('cancel'),
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'MuliSemiBold',
                      color: CupertinoColors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoButton(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text(
                    rightActionText,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'MuliBold',
                      color: rightActionColor,
                    ),
                  ),
                  onPressed: rightAction,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
