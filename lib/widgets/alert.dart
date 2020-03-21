import 'package:Flowby/constants.dart';
import 'package:Flowby/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Flowby/models/helper_functions.dart';

void showAlert({BuildContext context, String title, String description}) {
  HelperFunctions.showCustomDialog(
    context: context,
    dialog: CustomDialog(
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: kDialogTitleTextStyle,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            description,
            style: TextStyle(
                fontFamily: 'MuliBold',
                fontSize: 15,
                color: kTextFieldTextColor),
          ),
          CupertinoButton(
            child: Text(
              'Ok',
              style: TextStyle(
                  fontFamily: 'MuliBold',
                  fontSize: 15,
                  color: kDefaultProfilePicColor),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    ),
  );
}
