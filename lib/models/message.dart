class Message {
  String senderUid;
  String receiverUid;
  String text;
  var timestamp;

  Message({
    this.senderUid,
    this.receiverUid,
    this.text,
    this.timestamp,
  });

  Message.fromMap({Map<String, dynamic> map}) {
    this.senderUid = map['senderUid'];
    this.receiverUid = map['receiverUid'];
    this.text = map['text'];
    this.timestamp = map['timestamp']?.toDate() ?? DateTime.now();
  }
}
