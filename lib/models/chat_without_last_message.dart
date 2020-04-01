import 'package:equatable/equatable.dart';
import 'user.dart';

class ChatWithoutLastMessage extends Equatable {
  final String chatId;
  final User user1;
  final bool hasUser1Blocked;
  final User user2;
  final bool hasUser2Blocked;

  ChatWithoutLastMessage({
    this.chatId,
    this.user1,
    this.hasUser1Blocked = false,
    this.user2,
    this.hasUser2Blocked = false,
  });

  //needed to override equals operator
  @override
  List<Object> get props =>
      [user1, hasUser1Blocked, user2, hasUser2Blocked, chatId];

  @override
  String toString() {
    String toPrint = '\n{ user1: $user1, ';
    toPrint += 'hasUser1Blocked: $hasUser1Blocked, ';
    toPrint += 'user2: $user2, ';
    toPrint += 'hasUser2Blocked: $hasUser2Blocked, ';
    toPrint += 'chatId: $chatId, ';
    return toPrint;
  }
}
