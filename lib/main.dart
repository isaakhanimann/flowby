import 'package:flutter/material.dart';
import 'package:float/screens/welcome_screen.dart';
import 'package:float/screens/login_screen.dart';
import 'package:float/screens/registration_screen.dart';
import 'package:float/screens/create_profile_screen.dart';
import 'package:float/screens/chat_screen.dart';

void main() => runApp(Float());

class Float extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RegistrationScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        CreateProfileScreen.id: (context) => CreateProfileScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
