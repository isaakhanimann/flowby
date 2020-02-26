import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyableText extends StatelessWidget {
  final String text;
  final TextStyle style;

  CopyableText(this.text, {this.style});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Text(
          text,
          style: style,
        ),
        onLongPress: () {
          //print('Copied to clipboard');
          Clipboard.setData(ClipboardData(text: text));
          BotToast.showText(text:"Copied to clipboard");
        });
  }
}
