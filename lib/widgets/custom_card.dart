import 'package:flutter/cupertino.dart';
import 'package:Flowby/constants.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CustomCard extends StatelessWidget {
  final Widget leading;
  final Widget middle;
  final Function onPressed;
  final double paddingInsideHorizontal;
  final double paddingInsideVertical;

  CustomCard(
      {@required this.leading,
      @required this.middle,
      @required this.onPressed,
      this.paddingInsideHorizontal = 15,
      this.paddingInsideVertical = 10});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: CupertinoButton(
          color: kCardBackgroundColor,
          padding: EdgeInsets.symmetric(
              horizontal: paddingInsideHorizontal,
              vertical: paddingInsideVertical),
          borderRadius: BorderRadius.circular(15),
          child: Row(
            children: <Widget>[
              leading,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: middle,
                ),
              ),
              Icon(
                Feather.chevron_right,
                color: kDefaultProfilePicColor,
              ),
            ],
          ),
          onPressed: onPressed),
    );
  }
}
