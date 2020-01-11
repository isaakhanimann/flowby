import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    return position;
  }

//  static void getLastKnownPositionAndUploadIt(
//      {@required String userEmail}) async {
//    Position position = await Geolocator()
//        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.medium);
//    FirebaseConnection.uploadUsersLocation(uid: userEmail, position: position);
//  }

  StreamSubscription<Position> getPositionStreamSubscription() {
    //To listen for location changes you can subscribe to the onPositionChanged stream. Supply an instance of the LocationOptions class to configure the desired accuracy and the minimum distance change (in meters) before updates are send to the application.
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.medium, distanceFilter: 500);

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

  Stream<Position> getPositionStream() {
    //To listen for location changes you can subscribe to the onPositionChanged stream. Supply an instance of the LocationOptions class to configure the desired accuracy and the minimum distance change (in meters) before updates are send to the application.
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.medium, distanceFilter: 500);
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
