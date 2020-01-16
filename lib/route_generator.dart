import 'package:float/screens/choose_signup_or_login_screen.dart';
import 'package:float/screens/login_screen.dart';
import 'package:float/screens/navigation_screen.dart';
import 'package:float/screens/registration_screen.dart';
import 'package:float/screens/reset_password_screen.dart';
import 'package:float/screens/splash_screen.dart';
import 'package:float/screens/upload_picture_registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
//    //getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
//      case ChatScreen.id:
//        if (args is User) {
//          return CupertinoPageRoute(
//              builder: (_) => ChatScreen(
//                    otherUser: args,
//                  ));
//        }
//        return _errorRoute();
      case ChooseSignupOrLoginScreen.id:
        return CupertinoPageRoute(builder: (_) => ChooseSignupOrLoginScreen());
      case NavigationScreen.id:
        return CupertinoPageRoute(
            builder: (_) => NavigationScreen(loggedInUser: args));
      case LoginScreen.id:
        return CupertinoPageRoute(builder: (_) => LoginScreen());
      case RegistrationScreen.id:
        return CupertinoPageRoute(builder: (_) => RegistrationScreen());
      case SplashScreen.id:
        return CupertinoPageRoute(builder: (_) => SplashScreen());
      case ResetPasswordScreen.id:
        return CupertinoPageRoute(builder: (_) => ResetPasswordScreen());
      case UploadPictureRegistrationScreen.id:
        return CupertinoPageRoute(
            builder: (_) => UploadPictureRegistrationScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
