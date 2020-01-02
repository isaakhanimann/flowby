import 'package:flutter/cupertino.dart';

class Chat {
  String user1;
  String username1;
  String user2;
  String username2;
  String chatpath;
  String lastMessageText;
  var lastMessageTimestamp;

  Chat(
      {this.user1,
      this.username1,
      this.user2,
      this.username2,
      this.lastMessageText,
      this.lastMessageTimestamp});

  Chat.fromMap({Map<String, dynamic> map}) {
    this.user1 = map['user1'];
    this.username1 = map['username1'] ?? 'Default username1';
    this.user2 = map['user2'];
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
    String toPrint = '\n{ user1: $user1, ';
    toPrint += 'username1: $username1, ';
    toPrint += 'user2: $user2, ';
    toPrint += 'username2: $username2, ';
    toPrint += 'lastMessageText: $lastMessageText, ';
    toPrint += 'lastMessageTimestamp: ${lastMessageTimestamp.toString()} }\n';
    return toPrint;
  }
}
