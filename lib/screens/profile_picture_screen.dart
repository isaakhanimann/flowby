import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePictureScreen extends StatelessWidget {
  final String profilePictureUrl;
  final String otherUsername;
  final String heroTag;

  ProfilePictureScreen(
      {@required this.profilePictureUrl, @required this.otherUsername, @required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SafeArea(
        child: Hero(
          tag: heroTag,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(profilePictureUrl))),
          ),
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
                CupertinoIcons.back,
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
    ]);
  }
}
