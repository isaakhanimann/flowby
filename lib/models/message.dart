class Message {
  String sender;
  String text;
  var timestamp;

  Message({
    this.sender,
    this.text,
    this.timestamp,
  });

  Message.fromMap({Map<String, dynamic> map}) {
    this.sender = map['sender'];
    this.text = map['text'];
    this.timestamp = map['timestamp']?.toDate() ?? DateTime.now();
  }
}
