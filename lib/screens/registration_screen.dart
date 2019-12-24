import 'package:float/constants.dart';
import 'package:float/screens/create_profile_screen.dart';
import 'package:float/screens/login_screen.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:float/widgets/alert.dart';
import 'package:float/widgets/login_input_field.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../widgets/rounded_button.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  bool showSpinner = false;
  String username;
  String name;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.colorBurn),
          image: AssetImage("images/ff-story-3-bg.jpeg"),
          alignment: Alignment(1.0, 1.0),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                  isEmail: false,
                  placeholder: 'Full name',
                  setText: (value) {
                    name = value;
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),
                LoginInputField(
                  isEmail: false,
                  placeholder: 'Username',
                  setText: (value) {
                    username = value;
                  },
                ),
                SizedBox(
                  height: 8.0,
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
                  placeholder: 'Enter your password',
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
                    if (email == null || password == null) {
                      return;
                    }
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser = await FirebaseConnection.createUser(
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
                            showAlert(
                                context: context,
                                title: "Weak Password",
                                description: e.message);
                            break;
                          }
                        case 'ERROR_INVALID_EMAIL':
                          {
                            showAlert(
                                context: context,
                                title: "Invalid Email",
                                description:
                                    "Please enter a valid email address");
                            break;
                          }
                        case 'ERROR_EMAIL_ALREADY_IN_USE':
                          {
                            showAlert(
                                context: context,
                                title: "Email Already in Use",
                                description: e.message);
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
      ),
    );
  }
}
