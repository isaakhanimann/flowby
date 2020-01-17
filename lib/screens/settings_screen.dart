import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/screens/choose_signup_or_login_screen.dart';
import 'package:float/screens/edit_profile_screen.dart';
import 'package:float/services/firebase_auth_service.dart';
import 'package:float/widgets/sign_in_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  static const String id = 'settings_screen';

  final FirebaseUser loggedInUser;

  SettingsScreen({@required this.loggedInUser});

  List<SettingsItem> _buildSettingsChildren(BuildContext context) {
    return [
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
                return EditProfileScreen(
                  loggedInUser: loggedInUser,
                );
              },
            ),
          );
        },
      ),
      SettingsItem(
        leading: Icon(Icons.exit_to_app, color: kLoginBackgroundColor),
        title: Text('Sign Out', style: kUsernameTextStyle),
        onTap: () {
          final authService = Provider.of<FirebaseAuthService>(context);
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
      SettingsItem(
        leading: Icon(Icons.delete, color: kLoginBackgroundColor),
        title: Text('Delete Account', style: kUsernameTextStyle),
        onTap: () {
          showCupertinoDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you really want to delete all your info?'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text('Delete'),
                  onPressed: () async {
                    final authService =
                        Provider.of<FirebaseAuthService>(context);
                    print('delete user called');
                    await authService.deleteCurrentlyLoggedInUser();
                    Navigator.of(context).push(
                      CupertinoPageRoute<void>(
                        builder: (context) {
                          return ChooseSignupOrLoginScreen();
                        },
                      ),
                    );
                  },
                  isDestructiveAction: true,
                ),
              ],
            ),
          );
        },
      ),
      SettingsItem(
          leading: Icon(Icons.people, color: kLoginBackgroundColor),
          title: Text('Invite a friend'),
          onTap: null),
      SettingsItem(
          leading: Icon(Icons.add_to_home_screen, color: kLoginBackgroundColor),
          title: Text('Notifications'),
          onTap: null),
      SettingsItem(
          leading: Icon(Icons.bookmark, color: kLoginBackgroundColor),
          title: Text('Support'),
          onTap: null),
      SettingsItem(
          leading: Icon(Icons.description, color: kLoginBackgroundColor),
          title: Text('Terms & Conditions'),
          onTap: null),
      SettingsItem(
          leading: Icon(Icons.info, color: kLoginBackgroundColor),
          title: Text('Privacy Policy'),
          onTap: null),
      SettingsItem(
          leading: Icon(Icons.person, color: kLoginBackgroundColor),
          title: Text('My Data'),
          onTap: null)
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (loggedInUser == null) {
      return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.white,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.white,
          border: null,
        ),
        child: Center(
          child: SignInButton(),
        ),
      );
    }
    return Container(
      color: CupertinoColors.white,
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            backgroundColor: CupertinoColors.white,
            border: null,
            largeTitle: Text('Settings'),
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                _buildSettingsChildren(context),
                addAutomaticKeepAlives: true,
              ),
            ),
          )
        ],
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
