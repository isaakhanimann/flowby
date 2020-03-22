import 'package:flutter/cupertino.dart';
import 'user.dart';

class Announcement {
  User user;
  var timestamp;
  String text;
  String docId;

  Announcement({
    @required this.user,
    @required this.timestamp,
    @required this.text,
  });

  Announcement.fromMap({Map<String, dynamic> map}) {
    this.user = User.fromMap(map: map['user']);
    this.timestamp = map['timestamp']?.toDate();
    this.text = map['text'];
  }

  Map<String, dynamic> toMap() {
    return {'user': user.toMap(), 'timestamp': timestamp, 'text': text};
  }
}
