import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:provider/provider.dart';
import 'package:float/services/firebase_auth_service.dart';
import 'package:float/services/firebase_cloud_firestore_service.dart';

import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/widgets/alert.dart';
import 'package:float/widgets/login_input_field.dart';
import 'package:float/widgets/rounded_button.dart';

import 'package:float/screens/registration/upload_picture_registration_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  bool showSpinner = false;
  String userName;
  String name;
  String email;
  String password;

  var _nameController = TextEditingController();

  // var _userNameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();

  //final FocusNode _userNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

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
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Sign Up'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          backgroundColor: Color(0xFF0D4FF7),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 0.0,
                  ),
                  LoginInputField(
                    placeholder: 'Full name',
                    controller: _nameController,
                    focusNode: _nameFocus,
                    onFieldSubmitted: (term) {
                      FocusScope.of(context).requestFocus(_emailFocus);
                    },
                    isLast: false,
                    isEmail: true,
                    setText: (value) {
                      name = value;
                    },
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  /* LoginInputField(
                    placeholder: 'Username',
                    controller: _userNameController,
                    focusNode: _userNameFocus,
                    onFieldSubmitted: (term) {
                      FocusScope.of(context).requestFocus(_emailFocus);
                    },
                    isLast: false,
                    isEmail: true,
                    setText: (value) {
                      userName = value;
                    },
                  ),
                  SizedBox(
                    height: 8.0,
                  ),*/
                  LoginInputField(
                    placeholder: 'Email address',
                    controller: _emailController,
                    focusNode: _emailFocus,
                    onFieldSubmitted: (term) {
                      FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                    isLast: false,
                    isEmail: true,
                    setText: (value) {
                      email = value;
                    },
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  LoginInputField(
                    placeholder: 'Password',
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    onFieldSubmitted: (term) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    isLast: true,
                    isEmail: false,
                    setText: (value) {
                      password = value;
                    },
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  RoundedButton(
                    textColor: Colors.white,
                    color: ffDarkBlue,
                    text: 'Sign Up with Email',
                    onPressed: () async {
                      if (email == null || password == null) {
                        showAlert(
                            context: context,
                            title: "Missing email or password",
                            description:
                                'Enter an email and an password. Thank you.');
                        return;
                      }
                      try {
                        setState(() {
                          showSpinner = true;
                        });

                        final authService = Provider.of<FirebaseAuthService>(
                            context,
                            listen: false);
                        final cloudFirestoreService =
                            Provider.of<FirebaseCloudFirestoreService>(context,
                                listen: false);
                        final authResult = await authService.createUser(
                            email: email, password: password);

                        if (authResult != null) {
                          User user =
                              User(username: name, uid: authResult.user.uid);

                          print(user);

                          //await cloudFirestoreService.uploadUser(user: user);

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
                  Text(
                    'OR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'MontserratRegular',
                      fontSize: 18.0,
                    ),
                  ),
                  RoundedButton(
                    text: 'Sign Up with Facebook',
                    color: Color(0xFF4864B3),
                    textColor: Colors.white,
                    onPressed: null,
                  ),
                  RoundedButton(
                    text: 'Sign Up with Google',
                    color: Color(0xFFDD4B39),
                    textColor: Colors.white,
                    onPressed: null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
