import 'package:Flowby/app_localizations.dart';
import 'package:flutter/cupertino.dart';

class HelperFunctions {
  static String getTimestampAsString(
      {@required BuildContext context, @required DateTime timestamp}) {
    DateTime now = DateTime.now();
    if (now.difference(timestamp) < Duration(days: 1) &&
        now.day == timestamp.day) {
      //its today
      return _makeInt2Digits(timestamp.hour) +
          ':' +
          _makeInt2Digits(timestamp.minute);
    } else if (now.difference(timestamp) < Duration(days: 2)) {
      return AppLocalizations.of(context).translate('yesterday');
    } else if (now.difference(timestamp) < Duration(days: 7)) {
      return _getWeekdayString(context: context, weekdayInt: timestamp.weekday);
    } else {
      return _makeInt2Digits(timestamp.day) +
          ' ' +
          _getMonthString(context: context, month: timestamp.month);
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

  static String _getWeekdayString({BuildContext context, int weekdayInt}) {
    switch (weekdayInt) {
      case DateTime.monday:
        return AppLocalizations.of(context).translate('monday');
      case DateTime.tuesday:
        return AppLocalizations.of(context).translate('tuesday');
      case DateTime.wednesday:
        return AppLocalizations.of(context).translate('wednesday');
      case DateTime.thursday:
        return AppLocalizations.of(context).translate('thursday');
      case DateTime.friday:
        return AppLocalizations.of(context).translate('friday');
      case DateTime.saturday:
        return AppLocalizations.of(context).translate('saturday');
      case DateTime.sunday:
        return AppLocalizations.of(context).translate('sunday');
      default:
        return 'Error';
    }
  }

  static String _getMonthString({BuildContext context, int month}) {
    switch (month) {
      case 1:
        return AppLocalizations.of(context).translate('jan');
      case 2:
        return AppLocalizations.of(context).translate('feb');
      case 3:
        return AppLocalizations.of(context).translate('mar');
      case 4:
        return AppLocalizations.of(context).translate('apr');
      case 5:
        return AppLocalizations.of(context).translate('may');
      case 6:
        return AppLocalizations.of(context).translate('jun');
      case 7:
        return AppLocalizations.of(context).translate('jul');
      case 8:
        return AppLocalizations.of(context).translate('aug');
      case 9:
        return AppLocalizations.of(context).translate('sep');
      case 10:
        return AppLocalizations.of(context).translate('okt');
      case 11:
        return AppLocalizations.of(context).translate('nov');
      case 12:
        return AppLocalizations.of(context).translate('dez');
      default:
        return 'Error';
    }
  }
}
