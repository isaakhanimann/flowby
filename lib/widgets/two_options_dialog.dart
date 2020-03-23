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
        padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: kDialogTitleTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CupertinoButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'MuliRegular',
                      color: CupertinoColors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoButton(
                  child: Text(
                    rightActionText,
                    style: TextStyle(
                      fontSize: 20,
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
