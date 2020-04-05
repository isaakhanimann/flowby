import 'package:flutter/material.dart';
import 'two_options_dialog.dart';

class MarkInappropriateDialog extends StatelessWidget {
  final Function onWantsToMark;

  MarkInappropriateDialog({@required this.onWantsToMark});

  @override
  Widget build(BuildContext context) {
    return TwoOptionsDialog(
      title: "Is this user displaying inappropriate content?",
      text: "Do you want to mark this user as inappropriate?",
      rightActionText: "Yes",
      rightAction: onWantsToMark,
      rightActionColor: Colors.red,
    );
  }
}
