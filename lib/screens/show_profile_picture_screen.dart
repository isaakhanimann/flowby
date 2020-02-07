import 'package:Flowby/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShowProfilePictureScreen extends StatelessWidget {
  final String imageFileName;
  final String otherUsername;
  final String heroTag;

  ShowProfilePictureScreen(
      {@required this.imageFileName,
      @required this.otherUsername,
      @required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (param) {
        Navigator.of(context).pop();
      },
      child: CupertinoPageScaffold(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Stack(children: [
            Center(
              child: CachedNetworkImage(
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F$imageFileName?alt=media",
                imageBuilder: (context, imageProvider) {
                  return Hero(
                    transitionOnUserGestures: true,
                    tag: heroTag,
                    child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width / 2,
                        backgroundColor: Colors.grey,
                        backgroundImage: imageProvider),
                  );
                },
                placeholder: (context, url) => CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Feather.chevron_up,
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
        ),
      ),
    );
  }
}
