import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String username;
  String email;
  String skillHashtags;
  String wishHashtags;
  int skillRate;
  int wishRate;
  GeoPoint location;

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
}
