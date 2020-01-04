import 'package:flutter/material.dart';

import 'package:float/widgets/rounded_button.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:float/screens/splash_screen.dart';

class SettingsScreen extends StatelessWidget {
  static const String id = 'settings_screen';

  @override
  Widget build(BuildContext context) {
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
              FirebaseConnection.signOut();
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute<void>(
                  builder: (context) {
                    return SplashScreen();
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
