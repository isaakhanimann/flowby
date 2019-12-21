import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:float/services/location.dart';
import 'package:flutter/cupertino.dart';

class User {
  String username;
  String email;
  String skillHashtags;
  String wishHashtags;
  int skillRate;
  int wishRate;
  GeoPoint location;
  int distanceInKm;

  User(
      {this.username,
      this.email,
      this.skillHashtags,
      this.wishHashtags,
      this.skillRate,
      this.wishRate,
      this.location});

  User.fromMap({Map<String, dynamic> map}) {
    this.username = map['username'];
    this.email = map['email'];
    this.skillHashtags = map['skillHashtags'];
    this.wishHashtags = map['wishHashtags'];
    this.skillRate = map['skillRate'];
    this.wishRate = map['wishRate'];
    this.location = map['location'];
  }

  void updateDistanceToOtherUser({@required User otherUser}) async {
    this.distanceInKm =
        await getDistanceBetweenUsers(user1: this, user2: otherUser);
  }

  Future<int> getDistanceBetweenUsers(
      {@required User user1, @required User user2}) async {
    GeoPoint point1 = user1.location;
    GeoPoint point2 = user2.location;
    if (point1 == null || point2 == null) {
      return null;
    }
    double distanceInMeters = await Location.distanceBetween(
        startLatitude: point1.latitude,
        startLongitude: point1.longitude,
        endLatitude: point2.latitude,
        endLongitude: point2.longitude);
    int distanceInKm = (distanceInMeters / 1000).floor();
    return distanceInKm;
  }

  @override
  String toString() {
    String toPrint = 'username = $username, ';
    toPrint += 'email = $email, ';
    toPrint += 'skillHashtags = $skillHashtags, ';
    toPrint += 'wishHashtags = $wishHashtags, ';
    toPrint += 'skillRate = ${skillRate.toString()}, ';
    toPrint += 'location = ${location.toString()}, ';
    toPrint += 'distanceInKm = ${distanceInKm.toString()}, ';

    return toPrint;
  }
}
