import 'package:flutter/cupertino.dart';

class TimestampToString {
  static String getString({@required DateTime timestamp}) {
    int today = DateTime.now().day;
    if (today == timestamp.day) {
      return makeInt2Digits(timestamp.hour) +
          ':' +
          makeInt2Digits(timestamp.minute);
    } else if (today - 1 == timestamp.day) {
      return 'Yesterday';
    } else if (today - 7 < timestamp.day) {
      return getWeekdayString(timestamp.weekday);
    } else {
      return makeInt2Digits(timestamp.day) +
          ' ' +
          _getMonthString(timestamp.month);
    }
  }

  static String makeInt2Digits(int number) {
    if (number < 10) {
      return '0${number.toString()}';
    }
    return number.toString();
  }

  static String getWeekdayString(int weekdayInt) {
    switch (weekdayInt) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return 'Error';
    }
  }

  static String _getMonthString(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Okt';
      case 11:
        return 'Nov';
      case 12:
        return 'Dez';
      default:
        return 'Error';
    }
  }
}
