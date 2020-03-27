import 'package:flutter/material.dart';
import 'package:Flowby/constants.dart';

class CustomDialog extends StatelessWidget {
  final Widget child;

  CustomDialog({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 5,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10), child: child),
      backgroundColor: kCardBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }
}
