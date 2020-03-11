import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabHeader extends StatelessWidget {
  final Icon leftIcon;
  final Widget screenToNavigateToLeft;
  final Function onPressedLeft;
  final Icon rightIcon;
  final Widget screenToNavigateToRight;
  final Function onPressedRight;
  final Color backgroundColor;
  final bool whiteLogo;

  TabHeader({
    this.leftIcon,
    this.screenToNavigateToLeft,
    this.onPressedLeft,
    this.rightIcon,
    this.screenToNavigateToRight,
    this.onPressedRight,
    this.backgroundColor = Colors.white,
    this.whiteLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Container(
        decoration: BoxDecoration(color: backgroundColor),
        child: Stack(fit: StackFit.expand, children: [
          Image(
            image: whiteLogo
                ? AssetImage("assets/images/logo_flowby_white.png")
                : AssetImage("assets/images/logo_flowby.png"),
          ),
          Positioned(
            left: 0,
            child: CupertinoButton(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: leftIcon == null ? Container() : leftIcon,
                onPressed: onPressedLeft ??
                    () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute<void>(
                          builder: (context) {
                            return screenToNavigateToLeft;
                          },
                        ),
                      );
                    }),
          ),
          Positioned(
            right: 0,
            child: CupertinoButton(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: rightIcon == null ? Container() : rightIcon,
              onPressed: onPressedRight ??
                  () {
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute<void>(
                        builder: (context) {
                          return screenToNavigateToRight;
                        },
                      ),
                    );
                  },
            ),
          ),
        ]),
      ),
    );
  }
}
