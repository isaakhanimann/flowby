class UnreadMessages {
  int total = 0;

  UnreadMessages({
    this.total = 0,
  });

  UnreadMessages.fromMap({Map<String, dynamic> map}) {
    this.total = map['total'] ?? 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total,
    };
  }

  @override
  String toString() {
    String toPrint = '\n{';
    toPrint += 'total: ${total.toString()}, ';
    toPrint += '}\n';
    return toPrint;
  }
}

