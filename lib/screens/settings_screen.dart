import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/screens/choose_signup_or_login_screen.dart';
import 'package:float/screens/edit_profile_screen.dart';
import 'package:float/services/firebase_auth_service.dart';
import 'package:float/widgets/sign_in_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:share/share.dart';

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
          leading: Icon(Feather.share_2, color: kLoginBackgroundColor),
          title: Text('Invite your friends', style: kUsernameTextStyle),
          onTap: () => Share.share('Flowby is the largest skill-sharing community. The more the merrier! Join us with your flow: https://flowby.app/dl/')),
      SettingsItem(
        leading: Icon(Feather.log_out, color: kLoginBackgroundColor),
        title: Text('Sign Out', style: kUsernameTextStyle),
        onTap: () {
          final authService = Provider.of<FirebaseAuthService>(context);
          authService.signOut();
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            CupertinoPageRoute(
                builder: (BuildContext context) => ChooseSignupOrLoginScreen()),
            (Route<dynamic> route) => false,
          );
        },
      ),
      SettingsItem(
        leading: Icon(Feather.trash, color: kLoginBackgroundColor),
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
                    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                      CupertinoPageRoute(
                          builder: (BuildContext context) => ChooseSignupOrLoginScreen()),
                          (Route<dynamic> route) => false,
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
          leading: Icon(Feather.bell, color: kLoginBackgroundColor),
          title: Text('Notifications'),
          onTap: null),
      SettingsItem(
          leading: Icon(Feather.help_circle, color: kLoginBackgroundColor),
          title: Text('Support'),
          onTap: null),
      SettingsItem(
          leading: Icon(Feather.paperclip, color: kLoginBackgroundColor),
          title: Text('Terms & Conditions'),
          onTap: null),
      SettingsItem(
          leading: Icon(Feather.info, color: kLoginBackgroundColor),
          title: Text('Privacy Policy'),
          onTap: null),
      SettingsItem(
          leading: Icon(Feather.user, color: kLoginBackgroundColor),
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
        trailing: Icon(Feather.chevron_right),
      ),
    );
  }
}
