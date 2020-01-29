import 'package:Flowby/constants.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progress;

  ProgressBar({this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * progress,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 5.0, color: ffDarkBlue))),
    );
  }
}
