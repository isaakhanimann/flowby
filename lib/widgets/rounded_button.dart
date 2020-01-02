import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {@required this.color, this.textColor, @required this.onPressed, @required this.text});

  final Color color;
  final Color textColor;
  final Function onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: MaterialButton(
            onPressed: onPressed,
            minWidth: 200.0,
            height: 42.0,
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontFamily: 'MontserratRegular',
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
