import 'package:flutter/cupertino.dart';
import 'package:Flowby/models/user.dart';

class Chat {
  List<String> combinedUids;
  User user1;
  bool hasUser1Blocked;
  User user2;
  bool hasUser2Blocked;
  String chatpath;
  String lastMessageText;
  var lastMessageTimestamp;

  Chat(
      {this.combinedUids,
      this.user1,
      this.hasUser1Blocked,
      this.user2,
      this.hasUser2Blocked,
      this.lastMessageText,
      this.lastMessageTimestamp});

  Chat.fromMap({Map<String, dynamic> map}) {
    this.combinedUids = _convertFirebaseList(list: map['combinedUids']);
    this.user1 = User.fromMap(map: map['user1']);
    this.hasUser1Blocked = map['hasUser1Blocked'] ?? false;
    this.user2 = User.fromMap(map: map['user2']);
    this.hasUser2Blocked = map['hasUser2Blocked'] ?? false;
    this.lastMessageText = map['lastMessageText'] ?? 'No messages';
    this.lastMessageTimestamp =
        map['lastMessageTimestamp']?.toDate() ?? DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'combinedUids': combinedUids,
      'user1': user1.toMap(),
      'hasUser1Blocked': hasUser1Blocked,
      'user2': user2.toMap(),
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
    String toPrint = '\n{ user1: $user1, ';
    toPrint += 'combinedUids: $combinedUids';
    toPrint += 'hasUser1Blocked: $hasUser1Blocked, ';
    toPrint += 'user2: $user2, ';
    toPrint += 'hasUser2Blocked: $hasUser2Blocked, ';
    toPrint += 'lastMessageText: $lastMessageText, ';
    toPrint += 'lastMessageTimestamp: ${lastMessageTimestamp.toString()} }\n';
    return toPrint;
  }

  List<String> _convertFirebaseList({List<dynamic> list}) {
    List<String> newList = list.map((d) => d.toString()).toList();
    return newList;
  }
}
