import 'package:flutter/cupertino.dart';

class HelperFunctions {
  static String getTimestampAsString({@required DateTime timestamp}) {
    DateTime now = DateTime.now();
    if (now.difference(timestamp) < Duration(days: 1) &&
        now.day == timestamp.day) {
      //its today
      return _makeInt2Digits(timestamp.hour) +
          ':' +
          _makeInt2Digits(timestamp.minute);
    } else if (now.difference(timestamp) < Duration(days: 2)) {
      return 'Yesterday';
    } else if (now.difference(timestamp) < Duration(days: 7)) {
      return _getWeekdayString(timestamp.weekday);
    } else {
      return _makeInt2Digits(timestamp.day) +
          ' ' +
          _getMonthString(timestamp.month);
    }
  }

  static showCustomDialog(
      {@required BuildContext context, @required Widget dialog}) {
    showGeneralDialog(
        barrierColor: CupertinoColors.white.withOpacity(0.3),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: widget,
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 150),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return dialog;
        });
  }

  static String _makeInt2Digits(int number) {
    if (number < 10) {
      return '0${number.toString()}';
    }
    return number.toString();
  }

  static String _getWeekdayString(int weekdayInt) {
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
