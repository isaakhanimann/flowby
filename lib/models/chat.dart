import 'package:flutter/cupertino.dart';

class Chat {
  String uid1;
  String username1;
  String uid2;
  String username2;
  String chatpath;
  String lastMessageText;
  var lastMessageTimestamp;

  Chat(
      {this.uid1,
      this.username1,
      this.uid2,
      this.username2,
      this.lastMessageText,
      this.lastMessageTimestamp});

  Chat.fromMap({Map<String, dynamic> map}) {
    this.uid1 = map['uid1'];
    this.username1 = map['username1'] ?? 'Default username1';
    this.uid2 = map['uid2'];
    this.username2 = map['username2'] ?? 'Default username2';
    this.lastMessageText = map['lastMessageText'] ?? 'Default lastMessageText';
    this.lastMessageTimestamp =
        map['lastMessageTimestamp']?.toDate() ?? DateTime.now();
  }

  void setChatpath({@required String chatpath}) {
    this.chatpath = chatpath;
  }

  @override
  String toString() {
    String toPrint = '\n{ uid1: $uid1, ';
    toPrint += 'username1: $username1, ';
    toPrint += 'uid2: $uid2, ';
    toPrint += 'username2: $username2, ';
    toPrint += 'lastMessageText: $lastMessageText, ';
    toPrint += 'lastMessageTimestamp: ${lastMessageTimestamp.toString()} }\n';
    return toPrint;
  }
}
