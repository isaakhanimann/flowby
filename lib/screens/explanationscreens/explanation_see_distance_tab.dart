import 'package:Flowby/screens/navigation_screen.dart';
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
      color: CupertinoColors.activeOrange,
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
              'See how far away other users are',
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
                text: 'Enable Location')
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
        showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: Text('Location is enabled'),
            content: Text('\nYou have got all you need'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute<void>(
                      builder: (context) {
                        return NavigationScreen();
                      },
                    ),
                  );
                },
              )
            ],
          ),
        );
      } else {
        // get location because this function automatically asks for permission
        await locationService.getCurrentPosition();
      }
    } catch (e) {
      print(e);
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text('Location Permissions Denied'),
          content: Text('\nEnable Location Permissions in your Settings'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            )
          ],
        ),
      );
    }
  }
}
