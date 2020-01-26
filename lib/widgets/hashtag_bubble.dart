import 'package:Flowby/constants.dart';
import 'package:flutter/material.dart';

class HashtagBubble extends StatelessWidget {
  final String text;
  final Function onPress;
  HashtagBubble({@required this.text, @required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kDarkGreenColor,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: onPress,
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
