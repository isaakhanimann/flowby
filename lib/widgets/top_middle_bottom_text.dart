import 'package:flutter/cupertino.dart';
import 'package:Flowby/constants.dart';
import 'package:flutter_icons/flutter_icons.dart';

class TopMiddleBottomText extends StatelessWidget {
  final String topText;
  final String middleText;
  final String bottomText;

  TopMiddleBottomText(
      {@required this.topText,
      @required this.middleText,
      @required this.bottomText});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            topText,
            style: kExplanationTitleTextStyle,
            textAlign: TextAlign.center,
          ),
          Icon(
            Feather.arrow_down,
            size: 40,
          ),
          Text(
            middleText,
            style: kExplanationMiddleTextStyle,
            textAlign: TextAlign.center,
          ),
          Icon(
            Feather.arrow_down,
            size: 40,
          ),
          Text(
            bottomText,
            style: kExplanationMiddleTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
