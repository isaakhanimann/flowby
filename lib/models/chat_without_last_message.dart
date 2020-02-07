import 'package:equatable/equatable.dart';

class ChatWithoutLastMessage extends Equatable {
  final String uid1;
  final String username1;
  final String user1ImageFileName;
  final bool hasUser1Blocked;
  final String uid2;
  final String username2;
  final String user2ImageFileName;
  final bool hasUser2Blocked;
  final String chatpath;

  ChatWithoutLastMessage(
      {this.uid1,
      this.username1 = 'Default username1',
      this.user1ImageFileName,
      this.hasUser1Blocked = false,
      this.uid2,
      this.username2,
      this.user2ImageFileName,
      this.hasUser2Blocked = false,
      this.chatpath});

  //needed to override equals operator
  @override
  List<Object> get props => [
        uid1,
        username1,
        user1ImageFileName,
        hasUser1Blocked,
        uid2,
        username2,
        user2ImageFileName,
        hasUser2Blocked,
        chatpath
      ];

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
