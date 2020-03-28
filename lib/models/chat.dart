import 'package:Flowby/constants.dart';
import 'package:flutter/cupertino.dart';

class Chat {
  String uid1;
  String username1;
  String user1ImageFileName = kDefaultProfilePicName;
  int user1ImageVersionNumber = 1;
  bool hasUser1Blocked;
  String uid2;
  String username2;
  String user2ImageFileName = kDefaultProfilePicName;
  int user2ImageVersionNumber = 1;
  bool hasUser2Blocked;
  String chatpath;
  String lastMessageText;
  var lastMessageTimestamp;
  int unreadMessages1;
  int unreadMessages2;

  Chat({
    this.uid1,
    this.username1,
    this.user1ImageFileName = kDefaultProfilePicName,
    this.user1ImageVersionNumber = 1,
    this.hasUser1Blocked,
    this.uid2,
    this.username2,
    this.user2ImageFileName = kDefaultProfilePicName,
    this.user2ImageVersionNumber = 1,
    this.hasUser2Blocked,
    this.lastMessageText,
    this.lastMessageTimestamp,
    this.unreadMessages1 = 0,
    this.unreadMessages2 = 0,
  });

  Chat.fromMap({Map<String, dynamic> map}) {
    this.uid1 = map['uid1'];
    this.username1 = map['username1'] ?? 'Default username1';
    this.user1ImageFileName =
        map['user1ImageFileName'] ?? kDefaultProfilePicName;
    try {
      this.user1ImageVersionNumber = map['user1ImageVersionNumber'].round();
    } catch (e) {
      //could not convert double to int (because its infinity or NaN)
      this.user1ImageVersionNumber = 1;
    }
    this.hasUser1Blocked = map['hasUser1Blocked'] ?? false;
    this.uid2 = map['uid2'];
    this.username2 = map['username2'] ?? 'Default username2';
    this.user2ImageFileName =
        map['user2ImageFileName'] ?? kDefaultProfilePicName;
    try {
      this.user2ImageVersionNumber = map['user2ImageVersionNumber'].round();
    } catch (e) {
      //could not convert double to int (because its infinity or NaN)
      this.user2ImageVersionNumber = 1;
    }
    this.hasUser2Blocked = map['hasUser2Blocked'] ?? false;
    this.lastMessageText = map['lastMessageText'] ?? 'No messages';
    this.lastMessageTimestamp =
        map['lastMessageTimestamp']?.toDate() ?? DateTime.now();
    this.unreadMessages1 = map['unreadMessages1'] ?? 0;
    this.unreadMessages2 = map['unreadMessages2'] ?? 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'uid1': uid1,
      'username1': username1,
      'user1ImageFileName': user1ImageFileName,
      'user1ImageVersionNumber': user1ImageVersionNumber,
      'hasUser1Blocked': hasUser1Blocked,
      'uid2': uid2,
      'username2': username2,
      'user2ImageFileName': user2ImageFileName,
      'user2ImageVersionNumber': user2ImageVersionNumber,
      'hasUser2Blocked': hasUser2Blocked,
      'lastMessageText': lastMessageText,
      'lastMessageTimestamp': lastMessageTimestamp,
      'unreadMessages1' : unreadMessages1,
      'unreadMessages2' : unreadMessages2,
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
    toPrint += 'user1ImageVersionNumber: $user1ImageVersionNumber, ';
    toPrint += 'uid2: $uid2, ';
    toPrint += 'username2: $username2, ';
    toPrint += 'user2ImageFileName: $user2ImageFileName, ';
    toPrint += 'user2ImageVersionNumber: $user2ImageVersionNumber, ';
    toPrint += 'lastMessageText: $lastMessageText, ';
    toPrint += 'lastMessageTimestamp: ${lastMessageTimestamp.toString()} }\n';
    toPrint += 'unreadMessages1: $unreadMessages1, ';
    toPrint += 'unreadMessages2: $unreadMessages1, ';
    return toPrint;
  }
}
