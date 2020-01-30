import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GoogleLoginButton extends StatelessWidget {
  GoogleLoginButton(
      {@required this.color,
      this.textColor,
      @required this.onPressed,
      @required this.text,
      this.paddingInsideHorizontal = 50,
      this.paddingInsideVertical = 15});

  final Color color;
  final Color textColor;
  final Function onPressed;
  final String text;
  final double paddingInsideHorizontal;
  final double paddingInsideVertical;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(6.0),
        child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: CupertinoButton(
            onPressed: onPressed,
            padding: EdgeInsets.symmetric(
                horizontal: paddingInsideHorizontal,
                vertical: paddingInsideVertical),
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
