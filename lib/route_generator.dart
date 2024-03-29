import 'package:Flowby/screens/choose_signin_screen.dart';
import 'package:Flowby/screens/login_screen.dart';
import 'package:Flowby/screens/navigation_screen.dart';
import 'package:Flowby/screens/registration/registration_screen.dart';
import 'package:Flowby/screens/reset_password_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ChooseSigninScreen.id:
        return CupertinoPageRoute(builder: (_) => ChooseSigninScreen());
      case NavigationScreen.id:
        return CupertinoPageRoute(builder: (_) => NavigationScreen());
      case LoginScreen.id:
        return CupertinoPageRoute(builder: (_) => LoginScreen());
      case RegistrationScreen.id:
        return CupertinoPageRoute(builder: (_) => RegistrationScreen());
      case ResetPasswordScreen.id:
        return CupertinoPageRoute(builder: (_) => ResetPasswordScreen());
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
