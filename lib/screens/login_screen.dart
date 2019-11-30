import 'package:float/constants.dart';
import 'package:float/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:float/widgets/login_input_field.dart';
import 'package:float/widgets/alert.dart';
import 'package:float/screens/navigation_screen.dart';
import 'package:float/services/firebase_connection.dart';

FirebaseConnection connection = FirebaseConnection();

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kDarkGreenColor),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Login',
                style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: kDarkGreenColor,
                    letterSpacing: 3.0),
              ),
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
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final user = await connection.signIn(
                          email: email, password: password);
                      if (user != null) {
                        Navigator.pushNamed(context, NavigationScreens.id);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      switch (e.code) {
                        case 'ERROR_INVALID_EMAIL':
                          {
                            showAlert(
                                context: context,
                                title: "Invalid Email",
                                description: e.message);
                            break;
                          }
                        case 'ERROR_WRONG_PASSWORD':
                          {
                            showAlert(
                                context: context,
                                title: "Wrong Password",
                                description: e.message);
                            break;
                          }
                        case 'ERROR_USER_NOT_FOUND':
                          {
                            showAlert(
                                context: context,
                                title: "User not found",
                                description: e.message);
                            break;
                          }
                        case 'ERROR_USER_DISABLED':
                          {
                            showAlert(
                                context: context,
                                title: "User Disabled",
                                description: e.message);
                            break;
                          }
                        case 'ERROR_TOO_MANY_REQUESTS':
                          {
                            showAlert(
                                context: context,
                                title: "Too Many Requests",
                                description: e.message);
                            break;
                          }
                        case 'ERROR_OPERATION_NOT_ALLOWED':
                          {
                            showAlert(
                                context: context,
                                title: "Operation Not Allowed",
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
                  text: 'Log In'),
              SizedBox(
                height: 40.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                child: Text(
                  'Sign Up',
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
