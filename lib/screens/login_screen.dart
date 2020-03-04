import 'package:Flowby/constants.dart';
import 'package:Flowby/screens/navigation_screen.dart';
import 'package:Flowby/screens/reset_password_screen.dart';
import 'package:Flowby/services/firebase_auth_service.dart';
import 'package:Flowby/services/lifecycle_event_handler.dart';
import 'package:Flowby/widgets/alert.dart';
import 'package:Flowby/widgets/login_input_field.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:Flowby/widgets/verify_email_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:Flowby/services/apple_sign_in_available.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/widgets/google_login_button.dart';

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

  @override
  Widget build(BuildContext context) {
    // Observes the life cycle of the app.
    // If the user quits the app on the login screen then it will be signed out.
    // This prevents the user to be logged in without having verified the email.
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    WidgetsBinding.instance
        .addObserver(LifecycleEventHandler(detachedCallBack: () async {
      debugPrint('detached...');
      authService.signOut();
    }, resumeCallBack: () async {
      debugPrint('resume...');
    }));

    final appleSignInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      progressIndicator: SizedBox(
        width: 200,
        child: FlareActor(
          'assets/animations/liquid_loader.flr',
          alignment: Alignment.center,
          color: kDefaultProfilePicColor,
          fit: BoxFit.contain,
          animation: "Untitled",
        ),
      ),
      child: WillPopScope(
        onWillPop: () async {
          authService.signOut();
          return true;
        },
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
          backgroundColor: kLoginScreenBackgroundColor,
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
                    keyboardType: TextInputType.emailAddress,
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
                    obscureText: true,
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
                      color: kBlueButtonColor,
                      textColor: Colors.white,
                      onPressed: () async {
                        _signInWithEmail(context);
                      },
                      text: 'Log In'),
                  Text(
                    'OR',
                    textAlign: TextAlign.center,
                    style: kOrTextStyle,
                  ),
                  GoogleLoginButton(
                    text: 'Sign In with Google',
                    color: Color(0xFFDD4B39),
                    textColor: Colors.white,
                    onPressed: () {
                      _signInWithGoogle(context);
                    },
                  ),
                  if (appleSignInAvailable.isAvailable)
                    AppleSignInButton(
                      style: ButtonStyle.black,
                      type: ButtonType.signIn,
                      onPressed: () {
                        _signInWithApple(context);
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithEmail(BuildContext context) async {
    setState(() {
      showSpinner = true;
    });
    if (email == null || password == null) {
      return;
    }
    try {
      final authService =
          Provider.of<FirebaseAuthService>(context, listen: false);
      final authResult =
          await authService.signInWithEmail(email: email, password: password);
      final user = authResult?.user;
      if (user != null) {
        if (user.isEmailVerified == false) {
          showCupertinoDialog(
              context: context,
              builder: (_) => VerifyEmailAlert(
                    authService: authService,
                    authResult: authResult,
                  ));
          setState(() {
            showSpinner = false;
          });
          return;
        }
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
                description: "Please input a valid email address");
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
                description: "There is no user with this email address");
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
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      setState(() {
        showSpinner = true;
      });
      final authService =
          Provider.of<FirebaseAuthService>(context, listen: false);
      final FirebaseUser firebaseUser = await authService.signInWithGoogle();
      final cloudFirestoreService =
          Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
      User user = await cloudFirestoreService.getUser(uid: firebaseUser.uid);
      setState(() {
        showSpinner = false;
      });
      if (user != null) {
        //cleans the navigation stack, so we don't come back to the login page if we
        //press the back button in Android
        Navigator.of(context).pushNamedAndRemoveUntil(
          NavigationScreen.id,
          (Route<dynamic> route) => false,
          arguments: firebaseUser,
        );
      } else {
        showAlert(
            context: context,
            title: "Couldn't log in with Google",
            description: "Please sign up before you log in");
      }
    } catch (e) {
      print(e);
      setState(() {
        showSpinner = false;
      });
    }
  }

  Future<void> _signInWithApple(BuildContext context) async {
    setState(() {
      showSpinner = true;
    });
    try {
      final authService =
          Provider.of<FirebaseAuthService>(context, listen: false);
      final FirebaseUser firebaseUser = await authService.signInWithApple();
      final cloudFirestoreService =
          Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
      User user = await cloudFirestoreService.getUser(uid: firebaseUser.uid);
      setState(() {
        showSpinner = false;
      });
      if (user != null) {
        //cleans the navigation stack, so we don't come back to the login page if we
        //press the back button in Android
        Navigator.of(context).pushNamedAndRemoveUntil(
          NavigationScreen.id,
          (Route<dynamic> route) => false,
          arguments: firebaseUser,
        );
      } else {
        showAlert(
            context: context,
            title: "Couldn't log in with Apple",
            description: "Please sign up before you log in");
      }
    } catch (e) {
      switch (e.code) {
        case 'ERROR_AUTHORIZATION_DENIED':
          {
            showAlert(
                context: context,
                title: "Authorization Denied",
                description: "Please sign up with email");
            break;
          }
        default:
          {
            showAlert(
                context: context,
                title: "Apple Sign In didn't work",
                description: "Apple Sign In didn't work");
            print(e);
          }
      }
      setState(() {
        showSpinner = false;
      });
    }
  }
}
