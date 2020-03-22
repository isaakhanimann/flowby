import 'package:flutter/cupertino.dart';
import 'package:Flowby/constants.dart';
import 'custom_dialog.dart';

class BasicDialog extends StatelessWidget {
  final String title;
  final String text;

  BasicDialog({@required this.title, @required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 20, 5, 10),
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
            CupertinoButton(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                'Ok',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'MuliBold',
                  color: kDefaultProfilePicColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
