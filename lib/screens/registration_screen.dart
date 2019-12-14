import 'package:float/screens/create_profile_screen.dart';
import 'package:float/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/rounded_button.dart';
import 'package:float/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:float/widgets/login_input_field.dart';
import 'package:float/widgets/alert.dart';
import 'package:float/services/firebase_connection.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
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
                              description: e.message);
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
    );
  }
}
