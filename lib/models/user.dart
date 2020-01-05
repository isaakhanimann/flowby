import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:float/services/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class User {
  String username;
  String uid;
  String skillHashtags;
  String wishHashtags;
  int skillRate;
  int wishRate;
  GeoPoint location;
  int distanceInKm;

  User(
      {this.username,
      this.uid,
      this.skillHashtags,
      this.wishHashtags,
      this.skillRate,
      this.wishRate,
      this.location});

  User.fromMap({Map<String, dynamic> map}) {
    this.username = map['username'];
    this.uid = map['uid'];
    this.skillHashtags = map['skillHashtags'];
    this.wishHashtags = map['wishHashtags'];
    this.skillRate = map['skillRate'];
    this.wishRate = map['wishRate'];
    this.location = map['location'];
  }

  void updateDistanceToPositionIfPossible({@required Position position}) async {
    if (position == null || this.location == null) {
      return;
    }
    double distanceInMeters = await Location.distanceBetween(
        startLatitude: this.location.latitude,
        startLongitude: this.location.longitude,
        endLatitude: position.latitude,
        endLongitude: position.longitude);
    this.distanceInKm = (distanceInMeters / 1000).round();
  }

  @override
  String toString() {
    String toPrint = '\n{ username: $username, ';
    toPrint += 'uid: $uid, ';
    toPrint += 'skillHashtags: $skillHashtags, ';
    toPrint += 'wishHashtags: $wishHashtags, ';
    toPrint += 'skillRate: ${skillRate.toString()}, ';
    toPrint += 'location: ${location.toString()}, ';
    toPrint += 'distanceInKm: ${distanceInKm.toString()} }\n';

    return toPrint;
  }
}
