import 'package:flutter/cupertino.dart';

void showAlert({BuildContext context, String title, String description}) {
  showCupertinoDialog(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: Text(title),
      content: Text('\n' + description),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
