import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/registration/upload_picture_registration_screen.dart';
import 'package:Flowby/services/firebase_auth_service.dart';
import 'package:Flowby/widgets/alert.dart';
import 'package:Flowby/widgets/progress_bar.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class VerifyEmailScreen extends StatefulWidget {
  static const String id = 'verify_email_screen';

  final User user;

  VerifyEmailScreen({this.user});

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Stack(children: [
              Hero(
                child: ProgressBar(progress: 0),
                transitionOnUserGestures: true,
                tag: 'progress_bar',
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Thank you for joining us! 👋 \n\n A verification link has been sent to your email account. 💌 \n \n Click on the link to continue the registration process. ✔',
                        textAlign: TextAlign.center,
                        style: kRegisterHeaderTextStyle,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      RoundedButton(
                        text: 'Next',
                        color: kBlueButtonColor,
                        textColor: Colors.white,
                        onPressed: () {
                          _uploadUserAndNavigate(context);
                        },
                      ),
                    ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _uploadUserAndNavigate(BuildContext context) async {
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    FirebaseUser user = await authService.getCurrentUser();
    await user.reload();
    // The reload() function is not working as intended. See here: https://github.com/FirebaseExtended/flutterfire/issues/717
    // The workaround is to call a second time getCurrentUser()
    // https://pub.dev/packages/firebase_user_stream
    user = await authService.getCurrentUser();

    if (user.isEmailVerified == false) {
      showAlert(
          context: context,
          title: "Verify your email",
          description: 'It seems that you haven\'t verified your email yet.');
      return;
    }
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute<void>(
        builder: (context) {
          return UploadPictureRegistrationScreen(
            user: widget.user,
          );
        },
      ),
    );
  }
}
