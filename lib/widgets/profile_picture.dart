import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'centered_loading_indicator.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    Key key,
    @required this.imageFileName,
    @required this.imageVersionNumber,
    @required this.radius,
    @required this.heroTag,
  }) : super(key: key);

  final String imageFileName;
  final int imageVersionNumber;
  final double radius;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl:
          "https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F$imageFileName?alt=media&version=$imageVersionNumber",
      imageBuilder: (context, imageProvider) {
        return Hero(
          transitionOnUserGestures: true,
          tag: heroTag,
          child: CircleAvatar(
              radius: radius,
              backgroundColor: Colors.grey,
              backgroundImage: imageProvider),
        );
      },
      placeholder: (context, url) => SizedBox(
        width: 2 * radius,
        height: 2 * radius,
        child: CenteredLoadingIndicator(),
      ),
      errorWidget: (context, url, error) => SizedBox(
        width: 2 * radius,
        height: 2 * radius,
        child: Icon(Icons.error),
      ),
    );
  }
}
