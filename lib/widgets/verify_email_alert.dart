import 'package:Flowby/constants.dart';
import 'package:Flowby/services/firebase_auth_service.dart';
import 'package:Flowby/widgets/custom_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class VerifyEmailAlert extends StatelessWidget {
  final FirebaseAuthService authService;
  final AuthResult authResult;
  final FirebaseUser firebaseUser;

  VerifyEmailAlert({
    this.authService,
    this.authResult,
    this.firebaseUser,
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
              'Verify your email',
              style: kDialogTitleTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'It seems that you haven\'t verified your email yet.',
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
                    'Send verification',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'MuliBold',
                      color: kDefaultProfilePicColor,
                    ),
                  ),
                  onPressed: () async {
                    await authResult.user?.sendEmailVerification();
                    await firebaseUser?.sendEmailVerification();
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
