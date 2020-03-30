import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Badge extends StatelessWidget {
  final int count;
  final Color badgeColor;

  Badge({this.count, this.badgeColor});

  @override
  Widget build(BuildContext context) {
    return count > 0
        ? Container(
      padding: EdgeInsets.all(1),
      decoration: new BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(7.5),
      ),
      constraints: BoxConstraints(
        minWidth: 15,
        minHeight: 15,
      ),
      child: Text(
        count.toString(),
        style: new TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
        textAlign: TextAlign.center,
      ),
    )
        : Container();
  }
}