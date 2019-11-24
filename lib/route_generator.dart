import 'package:flutter/material.dart';
import 'package:float/main.dart';
import 'package:float/screens/chat_screen.dart';
import 'package:float/screens/create_profile_screen.dart';
import 'package:float/screens/home_screen.dart';
import 'package:float/screens/login_screen.dart';
import 'package:float/screens/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case ChatScreen.id:
        if (args is DocumentSnapshot) {
          return MaterialPageRoute(
              builder: (_) => ChatScreen(
                    otherUser: args,
                  ));
        }
        return _errorRoute();
      case CreateProfileScreen.id:
        //the underline stands for context
        return MaterialPageRoute(builder: (_) => CreateProfileScreen());
      case HomeScreen.id:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case LoginScreen.id:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RegistrationScreen.id:
        return MaterialPageRoute(builder: (_) => RegistrationScreen());
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
