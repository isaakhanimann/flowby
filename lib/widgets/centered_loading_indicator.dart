import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Flowby/constants.dart';

class CenteredLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
      ),
    );
  }
}
