import 'package:Flowby/services/location_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class User {
  String username;
  String uid;
  String bio;
  bool hasSkills;
  bool hasWishes;
  int skillRate;
  int wishRate;
  GeoPoint location;
  int distanceInKm;
  String imageFileName;
  Map<dynamic, dynamic> skills;
  Map<dynamic, dynamic> wishes;
  String skillKeywords;
  String wishKeywords;

  User(
      {this.username,
      this.uid,
      this.bio,
      this.hasSkills,
      this.hasWishes,
      this.skillRate,
      this.wishRate,
      this.location,
      this.imageFileName,
      this.skills,
      this.wishes});

  User.fromMap({Map<String, dynamic> map}) {
    this.username = map['username'];
    this.uid = map['uid'];
    this.bio = map['bio'];
    this.hasSkills = map['hasSkills'] ?? false;
    this.hasWishes = map['hasWishes'] ?? false;
    this.skillRate = map['skillRate'];
    this.wishRate = map['wishRate'];
    this.location = map['location'];
    this.imageFileName = map['imageFileName'];
    this.skills = map['skills'];
    this.wishes = map['wishes'];
    this.skillKeywords = _getKeywordString(skills);
    this.wishKeywords = _getKeywordString(wishes);
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uid': uid,
      'bio': bio,
      'hasSkills': hasSkills,
      'hasWishes': hasWishes,
      'skillRate': skillRate,
      'wishRate': wishRate,
      'imageFileName': imageFileName,
      'skills': skills,
      'wishes': wishes,
    };
  }

  String _getKeywordString(Map<dynamic, dynamic> map) {
    String result = '';
    if (map == null) {
      return result;
    }
    for (String key in map.keys) {
      result += key + ' ';
    }
    return result;
  }

  void updateDistanceToPositionIfPossible({@required Position position}) async {
    if (position == null || this.location == null) {
      return;
    }
    double distanceInMeters = await LocationService.distanceBetween(
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
    toPrint += 'bio: $bio, ';
    toPrint += 'hasSkills: $hasSkills, ';
    toPrint += 'hasWishes: $hasWishes, ';
    toPrint += 'skillRate: ${skillRate.toString()}, ';
    toPrint += 'location: ${location.toString()}, ';
    toPrint += 'imageFileName: ${imageFileName.toString()}, ';
    toPrint += 'skills: ${skills.toString()}, ';
    toPrint += 'wishes: ${wishes.toString()}, ';
    toPrint += 'skillKeywords: ${skillKeywords.toString()}, ';
    toPrint += 'wishKeywords: ${wishKeywords.toString()}, ';
    toPrint += 'distanceInKm: ${distanceInKm.toString()} }\n';

    return toPrint;
  }
}
