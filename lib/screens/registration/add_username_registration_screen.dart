import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/registration/upload_picture_registration_screen.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/widgets/alert.dart';
import 'package:Flowby/widgets/login_input_field.dart';
import 'package:Flowby/widgets/progress_bar.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class AddUsernameRegistrationScreen extends StatefulWidget {
  static const String id = 'add_username_registration_screen';

  final User user;

  AddUsernameRegistrationScreen({this.user});

  @override
  _AddUsernameRegistrationScreenState createState() =>
      _AddUsernameRegistrationScreenState();
}

class _AddUsernameRegistrationScreenState
    extends State<AddUsernameRegistrationScreen> {
  bool showSpinner = false;

  String _username;
  User _user;

  Future<void> _uploadUserAndNavigate({BuildContext context, User user}) async {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    await cloudFirestoreService.uploadUser(user: user);
    setState(() {
      showSpinner = false;
    });
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute<void>(
        builder: (context) {
          return UploadPictureRegistrationScreen(
            user: user,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.user != null ? _user = widget.user : print('error, no user found');
    // print(_user)

    return Container(
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
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
                          'What\'s your name?',
                          textAlign: TextAlign.center,
                          style: kRegisterHeaderTextStyle,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        LoginInputField(
                          isCapitalized: true,
                          placeholder: 'Full name',
                          isLast: false,
                          isEmail: true,
                          setText: (value) {
                            _username = value;
                          },
                        ),
                        RoundedButton(
                          text: 'Next',
                          color: kBlueButtonColor,
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_username == null) {
                              showAlert(
                                  context: context,
                                  title: "Full name is missing",
                                  description: 'Enter your name. Thank you.');
                              return;
                            }

                            setState(() {
                              showSpinner = true;
                            });

                            _user.username = _username;
                            _uploadUserAndNavigate(
                                context: context, user: _user);

                            setState(() {
                              showSpinner = false;
                            });
                          },
                        ),
                      ]),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
