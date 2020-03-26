import 'dart:async';

class NotificationsService {
  int nbrOfUnreadMessages;
  Map<String, List<String>> messages;

  NotificationsService({
    this.nbrOfUnreadMessages = 0,
    this.messages = const {
      "empty": ["empty"]
    },
  });

  StreamController<int> ctrlUnreadMessages = StreamController<int>();
  StreamController<Map<String, List<String>>> ctrlListOfMessages =
      StreamController<Map<String, List<String>>>();

  void incNbrOfUnreadMessages(int value) {
    nbrOfUnreadMessages += 1;
  }

  Stream getUnreadMessagesStream() {
    return ctrlUnreadMessages.stream;
  }

  Stream getListOfMessagesStream() {
    return ctrlListOfMessages.stream;
  }

  int getNbrOfUnreadMessages() {
    return nbrOfUnreadMessages;
  }
}
