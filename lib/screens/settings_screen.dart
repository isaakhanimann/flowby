import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:float/widgets/rounded_button.dart';
import 'package:float/screens/choose_signup_or_login_screen.dart';

import 'package:float/services/firebase_auth_service.dart';

class SettingsScreen extends StatelessWidget {
  static const String id = 'settings_screen';

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<FirebaseAuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            child: Text('Account Settings'),
            padding: EdgeInsets.only(left: 20.0),
          ),
          Text('Invite a friend'),
          Text('Notifications'),
          Text('Support'),
          Text('Terms & Conditions'),
          Text('Privacy Policy'),
          Text('My Data'),
          RoundedButton(
            text: 'Log Out',
            color: Colors.lightBlue,
            onPressed: () {
              authService.signOut();
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute<void>(
                  builder: (context) {
                    return ChooseSignupOrLoginScreen();
                  },
                ),
              );
            },
          ),
          RoundedButton(
            text: 'Delete Account',
            color: Colors.redAccent,
            onPressed: () {
              authService.deleteCurrentlyLoggedInUser();
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute<void>(
                  builder: (context) {
                    return ChooseSignupOrLoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
