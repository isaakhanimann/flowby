import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/screens/choose_signup_or_login_screen.dart';
import 'package:float/screens/create_profile_screen.dart';
import 'package:float/services/firebase_auth_service.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<FirebaseUser>(context, listen: false);
    if (loggedInUser == null) {
      return Center(
        child: RoundedButton(
          text: 'Sign In',
          color: kDarkGreenColor,
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<void>(
                builder: (context) {
                  return ChooseSignupOrLoginScreen();
                },
              ),
            );
          },
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Settings', style: kBigTitleTextStyle),
              SizedBox(
                height: 20,
              ),
              SettingsItem(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F${'default-profile-pic.jpg'}?alt=media'),
                ),
                title: Text('Edit Profile', style: kUsernameTextStyle),
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute<void>(
                      builder: (context) {
                        return CreateProfileScreen();
                      },
                    ),
                  );
                },
              ),
              SettingsItem(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out', style: kUsernameTextStyle),
                onTap: () async {
                  final authService = Provider.of<FirebaseAuthService>(context);
                  await authService.signOut();
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute<void>(
                      builder: (context) {
                        return ChooseSignupOrLoginScreen();
                      },
                    ),
                  );
                },
              ),
              SettingsItem(
                leading: Icon(Icons.delete),
                title: Text('Delete Account', style: kUsernameTextStyle),
                onTap: () {
                  final authService = Provider.of<FirebaseAuthService>(context);
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
        ),
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Function onTap;

  SettingsItem(
      {@required this.leading, @required this.title, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: kLightGrey2,
      margin: EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: ListTile(
        onTap: onTap,
        leading: leading,
        title: title,
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }
}
