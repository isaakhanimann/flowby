import 'package:flutter/cupertino.dart';

class Chat {
  String uid1;
  String username1;
  String user1ImageFileName;
  bool hasUser1Blocked;
  String uid2;
  String username2;
  String user2ImageFileName;
  bool hasUser2Blocked;
  String chatpath;
  String lastMessageText;
  var lastMessageTimestamp;

  Chat(
      {this.uid1,
      this.username1,
      this.user1ImageFileName,
      this.hasUser1Blocked,
      this.uid2,
      this.username2,
      this.user2ImageFileName,
      this.hasUser2Blocked,
      this.lastMessageText,
      this.lastMessageTimestamp});

  Chat.fromMap({Map<String, dynamic> map}) {
    this.uid1 = map['uid1'];
    this.username1 = map['username1'] ?? 'Default username1';
    this.user1ImageFileName = map['user1ImageFileName'];
    this.hasUser1Blocked = map['hasUser1Blocked'] ?? false;
    this.uid2 = map['uid2'];
    this.username2 = map['username2'] ?? 'Default username2';
    this.user2ImageFileName = map['user2ImageFileName'];
    this.hasUser2Blocked = map['hasUser2Blocked'] ?? false;
    this.lastMessageText = map['lastMessageText'] ?? 'Default lastMessageText';
    this.lastMessageTimestamp =
        map['lastMessageTimestamp']?.toDate() ?? DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'uid1': uid1,
      'username1': username1,
      'user1ImageFileName': user1ImageFileName,
      'hasUser1Blocked': hasUser1Blocked,
      'uid2': uid2,
      'username2': username2,
      'user2ImageFileName': user2ImageFileName,
      'hasUser2Blocked': hasUser2Blocked,
      'lastMessageText': lastMessageText,
      'lastMessageTimestamp': lastMessageTimestamp,
    };
  }

  void setChatpath({@required String chatpath}) {
    this.chatpath = chatpath;
  }

  @override
  String toString() {
    String toPrint = '\n{ uid1: $uid1, ';
    toPrint += 'username1: $username1, ';
    toPrint += 'user1ImageFileName: $user1ImageFileName, ';
    toPrint += 'uid2: $uid2, ';
    toPrint += 'username2: $username2, ';
    toPrint += 'user2ImageFileName: $user2ImageFileName, ';
    toPrint += 'lastMessageText: $lastMessageText, ';
    toPrint += 'lastMessageTimestamp: ${lastMessageTimestamp.toString()} }\n';
    return toPrint;
  }
}
