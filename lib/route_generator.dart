import 'package:float/models/user.dart';
import 'package:float/screens/chat_screen.dart';
import 'package:float/screens/login_screen.dart';
import 'package:float/screens/navigation_screen.dart';
import 'package:float/screens/registration_screen.dart';
import 'package:float/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case ChatScreen.id:
        if (args is User) {
          return MaterialPageRoute(
              builder: (_) => ChatScreen(
                    otherUser: args,
                  ));
        }
        return _errorRoute();
      case NavigationScreen.id:
        return MaterialPageRoute(builder: (_) => NavigationScreen());
      case LoginScreen.id:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RegistrationScreen.id:
        return MaterialPageRoute(builder: (_) => RegistrationScreen());
      case SplashScreen.id:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
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
