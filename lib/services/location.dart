import 'dart:async';

import 'package:float/services/firebase_connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  static Future<Position> getCurrentPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  static void getLastKnownPositionAndUploadIt(
      {@required String userEmail}) async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    FirebaseConnection.uploadUsersLocation(
        userEmail: userEmail, position: position);
  }

  static StreamSubscription<Position> getPositionStreamSubscription() {
    //To listen for location changes you can subscribe to the onPositionChanged stream. Supply an instance of the LocationOptions class to configure the desired accuracy and the minimum distance change (in meters) before updates are send to the application.
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 100);

    StreamSubscription<Position> positionStreamSubscription = Geolocator()
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

  static Stream<Position> getPositionStream() {
    //To listen for location changes you can subscribe to the onPositionChanged stream. Supply an instance of the LocationOptions class to configure the desired accuracy and the minimum distance change (in meters) before updates are send to the application.
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 100);
    Stream<Position> positionStream =
        Geolocator().getPositionStream(locationOptions);
    return positionStream;
  }

  static Future<double> distanceBetween(
      {@required double startLatitude,
      @required double startLongitude,
      @required double endLatitude,
      @required double endLongitude}) async {
    double distanceInMeters = await Geolocator().distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
    return distanceInMeters;
  }
}