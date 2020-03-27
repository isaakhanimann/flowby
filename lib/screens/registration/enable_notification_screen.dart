import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/screens/navigation_screen.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:Flowby/constants.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:Flowby/services/firebase_cloud_messaging.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/models/helper_functions.dart';
import 'package:Flowby/widgets/basic_dialog.dart';

class EnableNotificationScreen extends StatelessWidget {
  final User user;

  EnableNotificationScreen({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: double.infinity,
      color: CupertinoColors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Feather.bell,
              size: 50,
            ),
            SizedBox(height: 50),
            Text(
              AppLocalizations.of(context)
                  .translate('enable_notifications_to_get_notified'),
              style: kExplanationMiddleTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            RoundedButton(
              color: kBlueButtonColor,
              textColor: CupertinoColors.white,
              onPressed: () {
                _checkAndHandleNotificationPermissions(context);
              },
              text: AppLocalizations.of(context).translate('continue'),
            ),
          ],
        ),
      ),
    );
  }

  _checkAndHandleNotificationPermissions(BuildContext context) async {
    //just get the current location so the user is prompted to accept using the location
    final messagingService =
        Provider.of<FirebaseCloudMessaging>(context, listen: false);
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    try {
      messagingService.firebaseCloudMessagingListeners(context);
      messagingService.getToken().then((token) {
        cloudFirestoreService.uploadUsersPushToken(
            uid: user.uid, pushToken: token);
      });
      Navigator.of(context).pushNamedAndRemoveUntil(
        NavigationScreen.id,
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print(e);
      HelperFunctions.showCustomDialog(
        context: context,
        dialog: BasicDialog(
          title: AppLocalizations.of(context)
              .translate('notification_permissions_denied'),
          text: AppLocalizations.of(context)
              .translate('enable_notifications_in_settings'),
          onOkPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context).pushNamedAndRemoveUntil(
              NavigationScreen.id,
              (Route<dynamic> route) => false,
            );
          },
        ),
      );
    }
  }
}
