import 'dart:async';

class Notifications {
  int nbrOfUnreadMessages = 0;
  Map<String, List<String>> messages = {
    "empty": ["empty"]
  };

  Notifications();

  String receiverUid;
  String text;
  var timestamp;

  StreamController<int> ctrlUnreadMessages = StreamController<int>();
  StreamController<Map<String, List<String>>> ctrlListOfMessages =
      StreamController<Map<String, List<String>>>();

  void set1 (int value){
    nbrOfUnreadMessages = value;
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

  Notifications.fromMap({Map<String, dynamic> map}) {
    this.receiverUid = map['receiverUid'];
    this.text = map['text'];
    this.timestamp = map['timestamp']?.toDate() ?? DateTime.now();
  }

  toMap() {
    return {
      'text': text,
      'receiverUid': receiverUid,
      'timestamp': timestamp
    };
  }
}
