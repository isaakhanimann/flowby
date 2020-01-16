import 'package:flutter/material.dart';
import 'package:float/constants.dart';

class ProgressBar extends StatelessWidget {
  double progress;

  ProgressBar({this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*progress,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(width: 3.0, color: ffDarkBlue))),
    );
  }
}