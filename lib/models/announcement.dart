import 'package:Flowby/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  String uid;
  String username;
  String imageFileName;
  int imageVersionNumber;
  var timestamp;
  GeoPoint location;
  String text;

  Announcement(
      {this.uid,
      this.username,
      this.imageFileName,
      this.imageVersionNumber,
      this.timestamp,
      this.location,
      this.text});

  Announcement.fromMap({Map<String, dynamic> map}) {
    this.uid = map['uid'];
    this.username = map['username'];
    this.imageFileName = map['imageFileName'] ?? kDefaultProfilePicName;
    try {
      this.imageVersionNumber = map['imageVersionNumber'].round();
    } catch (e) {
      //could not convert double to int (because its infinity or NaN)
      this.imageVersionNumber = 1;
    }
    this.timestamp = map['timestamp']?.toDate() ?? DateTime.now();
    this.location = map['location'];
    this.text = map['text'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'imageFileName': imageFileName,
      'imageVersionNumber': imageVersionNumber,
      'timestamp': timestamp,
      'location': location,
      'text': text
    };
  }
}
