import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/constants.dart';
import 'package:Flowby/models/helper_functions.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/choose_signin_screen.dart';
import 'package:Flowby/services/firebase_auth_service.dart';
import 'package:Flowby/widgets/basic_dialog.dart';
import 'package:Flowby/widgets/custom_card.dart';
import 'package:Flowby/widgets/two_options_dialog.dart';
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
              AppLocalizations.of(context).translate('settings'),
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
          AppLocalizations.of(context).translate('sign_out'),
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
          AppLocalizations.of(context).translate('invite_friend'),
          style: kSettingsTextStyle,
        ),
        onTap: () => Share.share(
          AppLocalizations.of(context).translate('flowby_is'),
        ),
      ),
      SettingsItem(
          leading: Icon(Feather.message_circle, color: kLoginBackgroundColor),
          title: Text(
            AppLocalizations.of(context).translate('feedback'),
            style: kSettingsTextStyle,
          ),
          onTap: () {
            _launchURL(url: 'mailto:support@flowby.co?subject=Feedback');
          }),
      SettingsItem(
          leading: Icon(Feather.paperclip, color: kLoginBackgroundColor),
          title: Text(
            AppLocalizations.of(context).translate('terms_and_conditions'),
            style: kSettingsTextStyle,
          ),
          onTap: () {
            _launchURL(url: 'https://flowby.co/terms-and-conditions.pdf');
          }),
      SettingsItem(
          leading: Icon(Feather.info, color: kLoginBackgroundColor),
          title: Text(
            AppLocalizations.of(context).translate('privacy_policy'),
            style: kSettingsTextStyle,
          ),
          onTap: () {
            _launchURL(url: 'https://flowby.co/privacy-policy.pdf');
          }),
      SettingsItem(
          leading: Icon(Feather.user, color: kLoginBackgroundColor),
          title: Text(
            AppLocalizations.of(context).translate('acceptable_use_policy'),
            style: kSettingsTextStyle,
          ),
          onTap: () {
            _launchURL(url: 'https://flowby.co/acceptable-use-policy.pdf');
          }),
      SettingsItem(
        leading: Icon(Feather.trash, color: kLoginBackgroundColor),
        title: Text(
          AppLocalizations.of(context).translate('delete_account'),
          style: kSettingsTextStyle,
        ),
        onTap: () {
          HelperFunctions.showCustomDialog(
              context: context, dialog: DeleteDialog());
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
      onPress: onTap,
      paddingInsideVertical: 20,
    );
  }
}

class DeleteDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TwoOptionsDialog(
      title: AppLocalizations.of(context).translate('are_you_sure'),
      text: AppLocalizations.of(context).translate('really_delete'),
      rightActionText: AppLocalizations.of(context).translate('delete'),
      rightAction: () async {
        final authService =
            Provider.of<FirebaseAuthService>(context, listen: false);
        bool didDeleteWork = await authService.deleteCurrentlyLoggedInUser();
        if (!didDeleteWork) {
          Navigator.of(context, rootNavigator: true).pop();
          HelperFunctions.showCustomDialog(
              context: context, dialog: DeleteFailedDialog());
        } else {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            CupertinoPageRoute(
                builder: (BuildContext context) => ChooseSigninScreen()),
            (Route<dynamic> route) => false,
          );
        }
      },
      rightActionColor: Colors.red,
    );
  }
}

class DeleteFailedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasicDialog(
      title: AppLocalizations.of(context).translate('delete_failed'),
      text: AppLocalizations.of(context).translate('sign_out_then_sign_in'),
    );
  }
}
