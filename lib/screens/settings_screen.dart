import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/choose_signin_screen.dart';
import 'package:Flowby/services/firebase_auth_service.dart';
import 'package:Flowby/widgets/custom_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  static const String id = 'settings_screen';

  final User user;

  SettingsScreen({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.white,
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            leading: CupertinoButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Feather.chevron_left,
                  size: 35,
                )),
            backgroundColor: CupertinoColors.white,
            border: null,
            largeTitle: Text(
              'Settings',
            ),
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

  _launchURL({@required String url}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<SettingsItem> _buildSettingsChildren(BuildContext context) {
    return [
      SettingsItem(
        leading: Icon(Feather.log_out, color: kLoginBackgroundColor),
        title: Text(
          'Sign Out',
          style: kSettingsTextStyle,
        ),
        onTap: () {
          final authService =
              Provider.of<FirebaseAuthService>(context, listen: false);
          authService.signOut();
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            CupertinoPageRoute(
                builder: (BuildContext context) => ChooseSigninScreen()),
            (Route<dynamic> route) => false,
          );
        },
      ),
      SettingsItem(
        leading: Icon(Feather.share_2, color: kLoginBackgroundColor),
        title: Text(
          'Invite a friend',
          style: kSettingsTextStyle,
        ),
        onTap: () => Share.share(
            'Flowby is a close by community of people that share their skills in person. Join the adventure: https://flowby.app. Tell your friends about it, the more the merrier.'),
      ),
      SettingsItem(
          leading: Icon(Feather.message_circle, color: kLoginBackgroundColor),
          title: Text(
            'Feedback',
            style: kSettingsTextStyle,
          ),
          onTap: () {
            _launchURL(url: 'mailto:support@flowby.co?subject=Feedback');
          }),
      SettingsItem(
          leading: Icon(Feather.paperclip, color: kLoginBackgroundColor),
          title: Text(
            'Terms & Conditions',
            style: kSettingsTextStyle,
          ),
          onTap: () {
            _launchURL(url: 'https://flowby.co/terms-and-conditions.pdf');
          }),
      SettingsItem(
          leading: Icon(Feather.info, color: kLoginBackgroundColor),
          title: Text(
            'Privacy Policy',
            style: kSettingsTextStyle,
          ),
          onTap: () {
            _launchURL(url: 'https://flowby.co/privacy-policy.pdf');
          }),
      SettingsItem(
          leading: Icon(Feather.user, color: kLoginBackgroundColor),
          title: Text(
            'Acceptable Use Policy',
            style: kSettingsTextStyle,
          ),
          onTap: () {
            _launchURL(url: 'https://flowby.co/acceptable-use-policy.pdf');
          }),
      SettingsItem(
        leading: Icon(Feather.trash, color: kLoginBackgroundColor),
        title: Text(
          'Delete Account',
          style: kSettingsTextStyle,
        ),
        onTap: () {
          showCupertinoDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
              title: Text('Are you sure?'),
              content: Text('\nDo you really want to delete all your info?'),
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
                    final authService = Provider.of<FirebaseAuthService>(
                        context,
                        listen: false);
                    bool didDeleteWork =
                        await authService.deleteCurrentlyLoggedInUser();
                    if (!didDeleteWork) {
                      Navigator.of(context, rootNavigator: true).pop();
                      showCupertinoDialog(
                        context: context,
                        builder: (_) => CupertinoAlertDialog(
                          title: Text('Delete failed'),
                          content: Text(
                              '\nYou need to sign out and sign in again to delete your account'),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Text('Ok'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                        CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                ChooseSigninScreen()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                  isDestructiveAction: true,
                ),
              ],
            ),
          );
        },
      ),
    ];
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
    return CustomCard(
      leading: leading,
      middle: title,
      onPressed: onTap,
      paddingInsideVertical: 20,
    );
  }
}
