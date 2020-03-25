import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/constants.dart';
import 'package:Flowby/models/helper_functions.dart';
import 'package:Flowby/screens/navigation_screen.dart';
import 'package:Flowby/screens/reset_password_screen.dart';
import 'package:Flowby/services/firebase_auth_service.dart';
import 'package:Flowby/widgets/basic_dialog.dart';
import 'package:Flowby/widgets/login_input_field.dart';
import 'package:Flowby/widgets/rounded_button.dart';
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
import 'package:Flowby/widgets/two_options_dialog.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  String email = '';
  String password = '';

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
    /*
    WidgetsBinding.instance
        .addObserver(LifecycleEventHandler(detachedCallBack: () async {
      //debugPrint('detached...');
      authService.signOut();
    }, resumeCallBack: () async {
      //debugPrint('resume...');
    }));
*/

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
                AppLocalizations.of(context).translate('log_in'),
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
                    placeholder:
                        AppLocalizations.of(context).translate('email_address'),
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
                    placeholder:
                        AppLocalizations.of(context).translate('password'),
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
                      AppLocalizations.of(context)
                          .translate('forgot_your_password'),
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
                    text: AppLocalizations.of(context).translate('log_in'),
                  ),
                  Text(
                    AppLocalizations.of(context).translate('or'),
                    textAlign: TextAlign.center,
                    style: kOrTextStyle,
                  ),
                  GoogleLoginButton(
                    text: AppLocalizations.of(context)
                        .translate('sign_in_with_google'),
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
    try {
      final authService =
          Provider.of<FirebaseAuthService>(context, listen: false);
      final authResult =
          await authService.signInWithEmail(email: email, password: password);
      final user = authResult?.user;
      if (user != null) {
        if (user.isEmailVerified == false) {
          HelperFunctions.showCustomDialog(
            context: context,
            dialog: TwoOptionsDialog(
                title:
                    AppLocalizations.of(context).translate('verify_your_email'),
                text: AppLocalizations.of(context)
                    .translate('you_havent_verified'),
                rightActionText:
                    AppLocalizations.of(context).translate('send_verification'),
                rightAction: () async {
                  await user?.sendEmailVerification();
                  Navigator.pop(context);
                }),
          );
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
            HelperFunctions.showCustomDialog(
              context: context,
              dialog: BasicDialog(
                title: AppLocalizations.of(context).translate('invalid_email'),
                text: AppLocalizations.of(context)
                    .translate('please_input_valid_email'),
              ),
            );
            break;
          }
        case 'ERROR_WRONG_PASSWORD':
          {
            HelperFunctions.showCustomDialog(
              context: context,
              dialog: BasicDialog(
                  title:
                      AppLocalizations.of(context).translate('wrong_password'),
                  text: AppLocalizations.of(context)
                      .translate('password_invalid')),
            );
            break;
          }
        case 'ERROR_USER_NOT_FOUND':
          {
            HelperFunctions.showCustomDialog(
              context: context,
              dialog: BasicDialog(
                title: AppLocalizations.of(context).translate('user_not_found'),
                text: AppLocalizations.of(context)
                    .translate('no_user_with_email'),
              ),
            );
            break;
          }
        case 'ERROR_USER_DISABLED':
          {
            HelperFunctions.showCustomDialog(
              context: context,
              dialog: BasicDialog(
                  title:
                      AppLocalizations.of(context).translate('user_disabled'),
                  text: AppLocalizations.of(context)
                      .translate('this_user_disabled')),
            );
            break;
          }
        case 'ERROR_TOO_MANY_REQUESTS':
          {
            HelperFunctions.showCustomDialog(
              context: context,
              dialog: BasicDialog(
                  title: AppLocalizations.of(context)
                      .translate('too_many_requests'),
                  text: AppLocalizations.of(context)
                      .translate('too_many_requests_description')),
            );
            break;
          }
        default:
          {
            HelperFunctions.showCustomDialog(
              context: context,
              dialog: BasicDialog(
                  title:
                      AppLocalizations.of(context).translate('error_occured'),
                  text: AppLocalizations.of(context)
                      .translate('try_different_login_method')),
            );
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
        HelperFunctions.showCustomDialog(
          context: context,
          dialog: BasicDialog(
            title: AppLocalizations.of(context)
                .translate('could_not_log_in_with_google'),
            text:
                AppLocalizations.of(context).translate('sign_up_before_login'),
          ),
        );
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
        HelperFunctions.showCustomDialog(
          context: context,
          dialog: BasicDialog(
            title: AppLocalizations.of(context)
                .translate('could_not_login_with_apple'),
            text:
                AppLocalizations.of(context).translate('sign_up_before_login'),
          ),
        );
      }
    } catch (e) {
      switch (e.code) {
        case 'ERROR_AUTHORIZATION_DENIED':
          {
            HelperFunctions.showCustomDialog(
              context: context,
              dialog: BasicDialog(
                title: AppLocalizations.of(context)
                    .translate('authorization_denied'),
                text: AppLocalizations.of(context)
                    .translate('please_sign_up_with_email'),
              ),
            );
            break;
          }
        default:
          {
            HelperFunctions.showCustomDialog(
              context: context,
              dialog: BasicDialog(
                title: AppLocalizations.of(context)
                    .translate('could_not_login_with_apple'),
                text: AppLocalizations.of(context)
                    .translate('sign_up_before_login'),
              ),
            );
            print(e);
          }
      }
      setState(() {
        showSpinner = false;
      });
    }
  }
}
