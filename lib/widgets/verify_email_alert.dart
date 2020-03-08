import 'package:Flowby/services/firebase_auth_service.dart';
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
    return CupertinoAlertDialog(
      title: Text('Verify your email'),
      content: Text('\nIt seems that you haven\'t verified your email yet.'),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text('Send verification'),
          onPressed: () async {
            await authResult.user?.sendEmailVerification();
            await firebaseUser?.sendEmailVerification();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
