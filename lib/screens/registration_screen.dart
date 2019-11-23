import 'package:float/screens/create_profile_screen.dart';
import 'package:float/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/rounded_button.dart';
import 'package:float/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:float/widgets/login_input_field.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Sign Up', style: kBigTitleTextStyle),
              SizedBox(
                height: 48.0,
              ),
              LoginInputField(
                isEmail: true,
                setText: (value) {
                  email = value;
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              LoginInputField(
                isEmail: false,
                setText: (value) {
                  password = value;
                },
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: kDarkGreenColor,
                text: 'Register',
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      Navigator.pushNamed(context, CreateProfileScreen.id);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    switch (e.code) {
                      case 'ERROR_WEAK_PASSWORD':
                        {
                          Alert(
                            context: context,
                            title: "Weak Password",
                            desc: e.message,
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Ok",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                                color: kDarkGreenColor,
                              )
                            ],
                          ).show();
                          break;
                        }
                      case 'ERROR_INVALID_EMAIL':
                        {
                          Alert(
                            context: context,
                            title: "Invalid Email",
                            desc: e.message,
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Ok",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                                color: kDarkGreenColor,
                              )
                            ],
                          ).show();
                          break;
                        }
                      case 'ERROR_EMAIL_ALREADY_IN_USE':
                        {
                          Alert(
                            context: context,
                            title: "Email Already in Use",
                            desc: e.message,
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Ok",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                                color: kDarkGreenColor,
                              )
                            ],
                          ).show();
                          break;
                        }
                      default:
                        {
                          print(e);
                        }
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
              ),
              SizedBox(
                height: 40.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 25,
                    color: kDarkGreenColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
