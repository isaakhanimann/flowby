import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/navigation_screen.dart';
import 'package:Flowby/screens/registration/upload_picture_registration_screen.dart';
import 'package:Flowby/screens/reset_password_screen.dart';
import 'package:Flowby/services/firebase_auth_service.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/widgets/alert.dart';
import 'package:Flowby/widgets/login_input_field.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

//TODO: change box border when the user doesn't enter an input

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  String email;
  String password;

  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      progressIndicator: SizedBox(
        width: 200,
        child: FlareActor(
          'assets/animations/liquid_loader.flr',
          alignment: Alignment.center,
          color: Colors.white,
          fit: BoxFit.contain,
          animation: "Untitled",
        ),
      ),
      child: CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          border: null,
          leading: CupertinoButton(
            child: Icon(CupertinoIcons.back, color: CupertinoColors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          middle: Padding(
            padding: const EdgeInsets.only(top: 13.0),
            child: Text(
              'Log In',
              style: kCupertinoScaffoldTextStyle,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: kRegistrationBackgroundColor,
        child: SafeArea(
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
                  controller: _emailController,
                  focusNode: _emailFocus,
                  onFieldSubmitted: (term) {
                    FocusScope.of(context).requestFocus(_passwordFocus);
                  },
                  isLast: false,
                  isEmail: true,
                  placeholder: 'Email address',
                  setText: (value) {
                    email = value;
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),
                LoginInputField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  onFieldSubmitted: (term) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  isLast: true,
                  isEmail: false,
                  placeholder: 'Password',
                  setText: (value) {
                    password = value;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => ResetPasswordScreen()));
                  },
                  child: Text(
                    'Forgot your password?',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                RoundedButton(
                    color: ffDarkBlue,
                    textColor: Colors.white,
                    onPressed: () async {
                      if (email == null || password == null) {
                        return;
                      }
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final authService = Provider.of<FirebaseAuthService>(
                            context,
                            listen: false);
                        final authResult = await authService.signInWithEmail(
                            email: email, password: password);
                        final user = authResult?.user;
                        if (user != null) {
                          //cleans the navigation stack, so we don't come back to the login page if we
                          //press the back button in Android
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            NavigationScreen.id,
                            (Route<dynamic> route) => false,
                            arguments: user,
                          );
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
                    text: 'Log In'),
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
                  text: 'Log In with Facebook',
                  color: Color(0xFF4864B3),
                  textColor: Colors.white,
                  onPressed: null,
                ),
                RoundedButton(
                  text: 'Log In with Google',
                  color: Color(0xFFDD4B39),
                  textColor: Colors.white,
                  onPressed: () async {
                    try {
                      signInWithGoogle().then((authResult) {
                        //print('logged in');
                        //print(authResult);
                        final cloudFirestoreService =
                            Provider.of<FirebaseCloudFirestoreService>(context,
                                listen: false);

                        cloudFirestoreService
                            .getUser(uid: authResult.uid)
                            .then((_currentUser) {
                          print(_currentUser);
                          if (_currentUser == null) {
                            User user = User(
                                username: authResult.displayName,
                                uid: authResult.uid);

                            Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute<void>(
                                builder: (context) {
                                  return UploadPictureRegistrationScreen(
                                    user: user,
                                  );
                                },
                              ),
                            );
                          } else {
                            final user = authResult;
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              NavigationScreen.id,
                              (Route<dynamic> route) => false,
                              arguments: user,
                            );
                          }
                        });
                      });
                    } catch (e) {
                      print('ERROR: Google Sign In');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
