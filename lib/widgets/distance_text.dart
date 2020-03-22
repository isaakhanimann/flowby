import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/services/location_service.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:Flowby/constants.dart';

class DistanceText extends StatelessWidget {
  final latitude1;
  final longitude1;
  final latitude2;
  final longitude2;
  final double fontSize;

  DistanceText(
      {@required this.latitude1,
      @required this.longitude1,
      @required this.latitude2,
      @required this.longitude2,
      this.fontSize = 12});

  @override
  Widget build(BuildContext context) {
    final locationService =
        Provider.of<LocationService>(context, listen: false);
    return FutureBuilder(
      future: locationService.distanceBetween(
          startLatitude: latitude1,
          startLongitude: longitude1,
          endLatitude: latitude2,
          endLongitude: longitude2),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            snapshot.hasError) {
          return Text('');
        }

        int distanceInKm = snapshot.data;
        if (distanceInKm == null) {
          return Text('');
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Icon(
                Feather.navigation,
                size: fontSize,
                color: kBlueButtonColor,
              ),
            ),
            Flexible(
              flex: 3,
              child: Text(
                ' ' + distanceInKm.toString() + 'km',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: kBlueButtonColor,
                    fontSize: fontSize,
                    fontFamily: 'MuliRegular'),
              ),
            ),
          ],
        );
      },
    );
  }
}
