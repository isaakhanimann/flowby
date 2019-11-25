import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:float/constants.dart';

void showAlert({BuildContext context, String title, String description}) {
  Alert(
    context: context,
    title: title,
    desc: description,
    buttons: [
      DialogButton(
        child: Text(
          "Ok",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
        color: kDarkGreenColor,
      )
    ],
  ).show();
}
