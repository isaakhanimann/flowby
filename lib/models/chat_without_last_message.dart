import 'package:flutter/cupertino.dart';

class ChatWithoutLastMessage {
  String uid1;
  String username1;
  String user1ImageFileName;
  bool hasUser1Blocked;
  String uid2;
  String username2;
  String user2ImageFileName;
  bool hasUser2Blocked;
  String chatpath;

  ChatWithoutLastMessage({
    this.uid1,
    this.username1,
    this.user1ImageFileName,
    this.hasUser1Blocked,
    this.uid2,
    this.username2,
    this.user2ImageFileName,
    this.hasUser2Blocked,
  });

  ChatWithoutLastMessage.fromMap({Map<String, dynamic> map}) {
    this.uid1 = map['uid1'];
    this.username1 = map['username1'] ?? 'Default username1';
    this.user1ImageFileName = map['user1ImageFileName'];
    this.hasUser1Blocked = map['hasUser1Blocked'] ?? false;
    this.uid2 = map['uid2'];
    this.username2 = map['username2'] ?? 'Default username2';
    this.user2ImageFileName = map['user2ImageFileName'];
    this.hasUser2Blocked = map['hasUser2Blocked'] ?? false;
  }

  void setChatpath({@required String chatpath}) {
    this.chatpath = chatpath;
  }

  @override
  bool operator ==(other) {
    if (this.uid1 == other?.uid1 &&
        this.username1 == other?.username1 &&
        this.user1ImageFileName == other?.user1ImageFileName &&
        this.hasUser1Blocked == other?.hasUser1Blocked &&
        this.username2 == other?.username2 &&
        this.user2ImageFileName == other?.user2ImageFileName &&
        this.hasUser2Blocked == other?.hasUser2Blocked) {
      return true;
    } else {
      return false;
    }
  }

  @override
  String toString() {
    String toPrint = '\n{ uid1: $uid1, ';
    toPrint += 'username1: $username1, ';
    toPrint += 'user1ImageFileName: $user1ImageFileName, ';
    toPrint += 'uid2: $uid2, ';
    toPrint += 'username2: $username2, ';
    toPrint += 'user2ImageFileName: $user2ImageFileName, ';
    return toPrint;
  }
}
