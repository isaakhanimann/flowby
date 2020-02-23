import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyableText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;

  CopyableText({this.text, this.fontSize, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
          ),
        ),
        onLongPress: () {
          print('Copied to clipboard');
          Clipboard.setData(ClipboardData(text: text));
        });
  }
}
