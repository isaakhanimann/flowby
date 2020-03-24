import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/registration/verify_email_screen.dart';
import 'package:Flowby/services/firebase_auth_service.dart';
import 'package:Flowby/widgets/login_input_field.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:Flowby/services/apple_sign_in_available.dart';
import 'package:Flowby/widgets/google_login_button.dart';
import 'add_image_username_and_bio_registration_screen.dart';
import 'package:Flowby/models/helper_functions.dart';
import 'package:Flowby/widgets/basic_dialog.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  bool showSpinner = false;
  String email;
  String password;

  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
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
      child: CupertinoPageScaffold(
        resizeToAvoidBottomInset:
            false, //avoid the keyboard causing an overflow

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
              'Sign Up',
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
                  placeholder: 'Email address',
                  controller: _emailController,
                  focusNode: _emailFocus,
                  onFieldSubmitted: (term) {
                    FocusScope.of(context).requestFocus(_passwordFocus);
                  },
                  isLast: false,
                  keyboardType: TextInputType.emailAddress,
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
                  obscureText: true,
                  setText: (value) {
                    password = value;
                  },
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  textColor: Colors.white,
                  color: kBlueButtonColor,
                  text: 'Sign Up with Email',
                  onPressed: () {
                    _signInWithEmail(context);
                  },
                ),
                Text(
                  'OR',
                  textAlign: TextAlign.center,
                  style: kOrTextStyle,
                ),
                GoogleLoginButton(
                  text: 'Sign Up with Google',
                  color: Color(0xFFDD4B39),
                  textColor: Colors.white,
                  onPressed: () {
                    _signInWithGoogle(context);
                  },
                ),
                if (appleSignInAvailable.isAvailable)
                  AppleSignInButton(
                    style: ButtonStyle.black,
                    type: ButtonType.continueButton,
                    onPressed: () {
                      _signInWithApple(context);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _uploadUserAndNavigate({BuildContext context, User user}) async {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    await cloudFirestoreService.uploadUser(user: user);
    setState(() {
      showSpinner = false;
    });
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      CupertinoPageRoute(
          builder: (BuildContext context) =>
              AddImageUsernameAndBioRegistrationScreen(user: user)),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _signInWithEmail(BuildContext context) async {
    try {
      setState(() {
        showSpinner = true;
      });
      if (email == null || password == null) {
        HelperFunctions.showCustomDialog(
          context: context,
          dialog: BasicDialog(
              title: "Missing email or password",
              text: "Enter an email and an password. Thank you."),
        );
        setState(() {
          showSpinner = false;
        });
        return;
      }

      final authService =
          Provider.of<FirebaseAuthService>(context, listen: false);
      final cloudFirestoreService =
          Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
      final authResult =
          await authService.registerWithEmail(email: email, password: password);

      if (authResult != null) {
        User user = User(
          uid: authResult.user.uid,
        );
        await cloudFirestoreService.uploadUser(user: user);
        await authResult.user.sendEmailVerification();
        setState(() {
          showSpinner = false;
        });
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          CupertinoPageRoute(
              builder: (BuildContext context) => VerifyEmailScreen(user: user)),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      switch (e.code) {
        case 'ERROR_WEAK_PASSWORD':
          {
            HelperFunctions.showCustomDialog(
              context: context,
              dialog: BasicDialog(title: "Weak Password", text: e.message),
            );
            break;
          }
        case 'ERROR_INVALID_EMAIL':
          {
            HelperFunctions.showCustomDialog(
              context: context,
              dialog: BasicDialog(
                  title: "Invalid Email",
                  text: "Please enter a valid email address"),
            );
            break;
          }
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          {
            HelperFunctions.showCustomDialog(
              context: context,
              dialog:
                  BasicDialog(title: "Email Already in Use", text: e.message),
            );
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
      User user = User(
          username: firebaseUser.displayName,
          uid: firebaseUser.uid,
          imageFileName: 'default-profile-pic.jpg');
      _uploadUserAndNavigate(context: context, user: user);
      setState(() {
        showSpinner = false;
      });
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
      User user = User(
          username: firebaseUser.displayName,
          uid: firebaseUser.uid,
          imageFileName: kDefaultProfilePicName);
      _uploadUserAndNavigate(context: context, user: user);
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      switch (e.code) {
        case 'ERROR_AUTHORIZATION_DENIED':
          {
            HelperFunctions.showCustomDialog(
              context: context,
              dialog: BasicDialog(
                  title: "Authorization Denied",
                  text: "Please sign up with email"),
            );
            break;
          }
        default:
          {
            HelperFunctions.showCustomDialog(
              context: context,
              dialog: BasicDialog(
                  title: "Apple Sign In didn't work",
                  text: "Sign in with a different method"),
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
