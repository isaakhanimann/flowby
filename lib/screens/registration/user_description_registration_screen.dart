import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/registration/add_languages_registration_screen.dart';
import 'package:Flowby/widgets/progress_bar.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';

class UserDescriptionRegistrationScreen extends StatefulWidget {
  static const String id = 'user_description_registration_screen';

  final User user;

  UserDescriptionRegistrationScreen({this.user});

  @override
  _UserDescriptionRegistrationScreenState createState() =>
      _UserDescriptionRegistrationScreenState();
}

class _UserDescriptionRegistrationScreenState
    extends State<UserDescriptionRegistrationScreen> {
  bool showSpinner = false;

  String _bio;

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
                child: ProgressBar(progress: 0.4),
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
                        height: 20.0,
                      ),
                      Text(
                        'Let the others know who you are',
                        textAlign: TextAlign.center,
                        style: kRegisterHeaderTextStyle,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      CupertinoTextField(
                        style: kEditProfileTextFieldTextStyle,
                        placeholder: 'Your biography...',
                        maxLength: 200,
                        maxLines: 4,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: kBoxBorderColor),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),
                        onChanged: (value) {
                          _bio = value;
                        },
                        textAlign: TextAlign.start,
                      ),
                      RoundedButton(
                        text: 'Next',
                        color: kBlueButtonColor,
                        textColor: Colors.white,
                        onPressed: () {
                          _uploadUserAndNavigate(context);
                        },
                      ),
                      Text(
                        'We love real people with real stories.',
                        textAlign: TextAlign.center,
                        style: kRegisterHeaderTextStyle,
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
    setState(() {
      showSpinner = true;
    });
    widget.user.bio = _bio;
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    await cloudFirestoreService.uploadUser(user: widget.user);
    setState(() {
      showSpinner = false;
    });
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute<void>(
        builder: (context) {
          return AddLanguagesRegistrationScreen(user: widget.user);
        },
      ),
    );
  }
}
