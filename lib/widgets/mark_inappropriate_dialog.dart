import 'package:Flowby/app_localizations.dart';
import 'package:flutter/material.dart';
import 'two_options_dialog.dart';

class MarkInappropriateDialog extends StatelessWidget {
  final Function onWantsToMark;

  MarkInappropriateDialog({@required this.onWantsToMark});

  @override
  Widget build(BuildContext context) {
    return TwoOptionsDialog(
      title: AppLocalizations.of(context)
          .translate("is_displaying_inappropriate_content"),
      text:
          AppLocalizations.of(context).translate("mark_user_as_inappropriate"),
      rightActionText: AppLocalizations.of(context).translate("yes"),
      rightAction: onWantsToMark,
      rightActionColor: Colors.red,
    );
  }
}
