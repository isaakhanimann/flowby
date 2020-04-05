import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/services/location_service.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:Flowby/constants.dart';

class CityAndDistanceText extends StatefulWidget {
  final latitude1;
  final longitude1;
  final latitude2;
  final longitude2;
  final double fontSize;

  CityAndDistanceText(
      {@required this.latitude1,
      @required this.longitude1,
      @required this.latitude2,
      @required this.longitude2,
      this.fontSize = 12});

  @override
  _CityAndDistanceTextState createState() => _CityAndDistanceTextState();
}

class _CityAndDistanceTextState extends State<CityAndDistanceText> {
  Future<String> cityFuture;
  Future<int> distanceFuture;

  @override
  void initState() {
    super.initState();
    final locationService =
        Provider.of<LocationService>(context, listen: false);
    cityFuture = locationService.getCity(
        latitude: widget.latitude2, longitude: widget.longitude2);
    distanceFuture = locationService.distanceBetween(
        startLatitude: widget.latitude1,
        startLongitude: widget.longitude1,
        endLatitude: widget.latitude2,
        endLongitude: widget.longitude2);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        FutureBuilder(
          future: cityFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done ||
                snapshot.hasError) {
              return Text('');
            }

            String currentCity = snapshot.data;
            if (currentCity == null || currentCity == '') {
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
                    ' ' + currentCity,
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
        ),
        FutureBuilder(
          future: distanceFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done ||
                snapshot.hasError) {
              return Text('');
            }

            int distanceInKm = snapshot.data;
            if (distanceInKm == kAlmostInfiniteDistanceInKm) {
              return Text('');
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: Text(
                    ', ' + distanceInKm.toString() + 'km',
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
        ),
      ],
    );
  }
}
