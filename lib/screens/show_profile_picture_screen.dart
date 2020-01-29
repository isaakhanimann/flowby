import 'package:Flowby/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ShowProfilePictureScreen extends StatelessWidget {
  final String profilePictureUrl;
  final String otherUsername;
  final String heroTag;

  ShowProfilePictureScreen(
      {@required this.profilePictureUrl,
      @required this.otherUsername,
      @required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(children: [
        Hero(
          transitionOnUserGestures: true,
          tag: heroTag,
          child: GestureDetector(
            onPanUpdate: (param) {
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(profilePictureUrl))),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 35.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Feather.chevron_left,
                  color: kLoginBackgroundColor,
                  size: 30,
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text(
                  otherUsername,
                  style: TextStyle(
                      color: kLoginBackgroundColor,
                      fontSize: 22,
                      fontFamily: 'MontserratRegular'),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
