class Message {
  String senderUid;
  String text;
  var timestamp;

  Message({
    this.senderUid,
    this.text,
    this.timestamp,
  });

  Message.fromMap({Map<String, dynamic> map}) {
    this.senderUid = map['senderUid'];
    this.text = map['text'];
    this.timestamp = map['timestamp']?.toDate() ?? DateTime.now();
  }
}
