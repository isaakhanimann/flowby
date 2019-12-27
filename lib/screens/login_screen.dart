import 'package:float/constants.dart';
import 'package:float/screens/navigation_screen.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:float/widgets/alert.dart';
import 'package:float/widgets/login_input_field.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
  void initState() {
    super.initState();
    FirebaseConnection.autoLogin(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.colorBurn),
          image: AssetImage("images/Freeflowter_Stony_Fond1.png"),
          alignment: Alignment(0.0, 0.0),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Log In'),
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            progressIndicator: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kDarkGreenColor),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 48.0,
                  ),
                  LoginInputField(
                    isLast: false,
                    isEmail: true,
                    placeholder: 'Enter your email',
                    setText: (value) {
                      email = value;
                    },
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  LoginInputField(
                    isLast: true,
                    isEmail: false,
                    placeholder: 'Enter your password',
                    setText: (value) {
                      password = value;
                    },
                  ),
                  Text(
                    'Forgot your password?',
                    textAlign: TextAlign.left,
                  ),
                  RoundedButton(
                      color: kDarkGreenColor,
                      onPressed: () async {
                        if (email == null || password == null) {
                          return;
                        }
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final user = await FirebaseConnection.signIn(
                              email: email, password: password);
                          if (user != null) {
                            //Navigator.pushNamed(context, NavigationScreens.id);
                            //cleans the navigation stack, so we don't come back to the login page if we
                            //press the back button in Android
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                NavigationScreen.id,
                                (Route<dynamic> route) => false);
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
                                    description:
                                        "Please input a valid email address");
                                break;
                              }
                            case 'ERROR_WRONG_PASSWORD':
                              {
                                showAlert(
                                    context: context,
                                    title: "Wrong Password",
                                    description: "The password is invalid");
                                break;
                              }
                            case 'ERROR_USER_NOT_FOUND':
                              {
                                showAlert(
                                    context: context,
                                    title: "User not found",
                                    description:
                                        "There is no user with this email address");
                                break;
                              }
                            case 'ERROR_USER_DISABLED':
                              {
                                showAlert(
                                    context: context,
                                    title: "User Disabled",
                                    description: "This user is disabled");
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
                      text: 'Login'),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'OR',
                    textAlign: TextAlign.center,
                  ),
                  RoundedButton(
                    color: Colors.blueAccent[100],
                    text: 'Log In with Facebook',
                    onPressed: null,
                  ),
                  RoundedButton(
                    color: Colors.redAccent[100],
                    text: 'Log In with Google',
                    onPressed: null,
                  ),
                  /*GestureDetector(
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
                ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
