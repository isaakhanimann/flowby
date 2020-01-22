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
    return SafeArea(
      child: Stack(children: [
        Hero(
          tag: heroTag,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(profilePictureUrl))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Feather.chevron_left,
                  color: CupertinoColors.white,
                  size: 30,
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text(
                  otherUsername,
                  style: TextStyle(
                      color: Colors.white,
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
