import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/services/location_service.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:Flowby/constants.dart';

class DistanceText extends StatefulWidget {
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
  _DistanceTextState createState() => _DistanceTextState();
}

class _DistanceTextState extends State<DistanceText> {
  Future<int> distanceFuture;

  @override
  void initState() {
    super.initState();
    final locationService =
        Provider.of<LocationService>(context, listen: false);
    distanceFuture = locationService.distanceBetween(
        startLatitude: widget.latitude1,
        startLongitude: widget.longitude1,
        endLatitude: widget.latitude2,
        endLongitude: widget.longitude2);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: distanceFuture,
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
                size: widget.fontSize,
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
                    fontSize: widget.fontSize,
                    fontFamily: 'MuliRegular'),
              ),
            ),
          ],
        );
      },
    );
  }
}
