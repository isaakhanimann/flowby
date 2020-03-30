import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/models/helper_functions.dart';
import 'package:Flowby/screens/navigation_screen.dart';
import 'package:Flowby/widgets/basic_dialog.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:Flowby/constants.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:Flowby/services/location_service.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class ExplanationSeeDistanceTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: double.infinity,
      color: kLightYellowColor,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Feather.navigation,
              size: 50,
            ),
            SizedBox(height: 50),
            Text(
              AppLocalizations.of(context).translate('see_how_far_away'),
              style: kExplanationMiddleTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            RoundedButton(
              color: kBlueButtonColor,
              textColor: CupertinoColors.white,
              onPressed: () {
                _checkAndHandleLocationPermissions(context);
              },
              text: AppLocalizations.of(context).translate('enable_location'),
            )
          ],
        ),
      ),
    );
  }

  _checkAndHandleLocationPermissions(BuildContext context) async {
    //just get the current location so the user is prompted to accept using the location
    final locationService =
        Provider.of<LocationService>(context, listen: false);
    try {
      GeolocationStatus status =
          await locationService.checkGeolocationPermissionStatus();
      if (status == GeolocationStatus.granted) {
        HelperFunctions.showCustomDialog(
          context: context,
          dialog: BasicDialog(
            title:
                AppLocalizations.of(context).translate('location_is_enabled'),
            text:
                AppLocalizations.of(context).translate('you_have_all_you_need'),
            onOkPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                CupertinoPageRoute(
                    builder: (BuildContext context) => NavigationScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        );
      } else {
        // get location because this function automatically asks for permission
        await locationService.getCurrentPosition();
      }
    } catch (e) {
      print(e);
      HelperFunctions.showCustomDialog(
        context: context,
        dialog: BasicDialog(
          title: AppLocalizations.of(context)
              .translate('location_permission_denied'),
          text: AppLocalizations.of(context)
              .translate('enable_location_in_settings'),
        ),
      );
    }
  }
}
