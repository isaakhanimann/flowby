import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class Location {
  var geolocator = Geolocator();

  Future<Position> getCurrentPosition() async {
    Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<Position> getLastKnownPosition() async {
    Position position = await geolocator.getLastKnownPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  StreamSubscription<Position> getPositionStreamSubscription() {
    //To listen for location changes you can subscribe to the onPositionChanged stream. Supply an instance of the LocationOptions class to configure the desired accuracy and the minimum distance change (in meters) before updates are send to the application.
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 100);

    StreamSubscription<Position> positionStreamSubscription = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      print(position == null
          ? 'Unknown'
          : position.latitude.toString() +
              ', ' +
              position.longitude.toString());
    });
    return positionStreamSubscription;
  }

  Stream<Position> getPositionStream() {
    //To listen for location changes you can subscribe to the onPositionChanged stream. Supply an instance of the LocationOptions class to configure the desired accuracy and the minimum distance change (in meters) before updates are send to the application.
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 100);
    Stream<Position> positionStream =
        geolocator.getPositionStream(locationOptions);
    return positionStream;
  }

  Future<double> distanceBetween(
      {@required double startLatitude,
      @required double startLongitude,
      @required double endLatitude,
      @required double endLongitude}) async {
    double distanceInMeters = await geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
    return distanceInMeters;
  }
}
