import 'dart:async';
import 'package:Flowby/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    return position;
  }

  Future<GeolocationStatus> checkGeolocationPermissionStatus() async {
    return Geolocator().checkGeolocationPermissionStatus();
  }

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

  Future<int> distanceBetween(
      {@required double startLatitude,
      @required double startLongitude,
      @required double endLatitude,
      @required double endLongitude}) async {
    if (startLatitude == null ||
        startLongitude == null ||
        endLatitude == null ||
        endLongitude == null) {
      return kAlmostInfiniteDistanceInKm;
    }
    double distanceInMeters = await Geolocator().distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
    int distanceInKm = (distanceInMeters / 1000).round();
    return distanceInKm;
  }

  Future<String> getCity(
      {@required double latitude, @required double longitude}) async {
    if (latitude == null || longitude == null) {
      return '';
    }
    try {
      List<Placemark> placemarks =
          await Geolocator().placemarkFromCoordinates(latitude, longitude);
      return placemarks[0]?.locality;
    } catch (e) {
      print('Could not get city name');
      print(e);
      return '';
    }
  }
}
