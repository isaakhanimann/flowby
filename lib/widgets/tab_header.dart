import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabHeader extends StatelessWidget {
  final Widget leftIcon;
  final Widget leftAction;
  final Widget rightIcon;
  final Widget rightAction;
  final Color backgroundColor;
  final bool whiteLogo;

  TabHeader({
    this.leftIcon,
    this.leftAction,
    this.rightIcon,
    this.rightAction,
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
            image: whiteLogo ? AssetImage("assets/images/logo_flowby_white.png") : AssetImage("assets/images/logo_flowby.png"),
          ),
          Positioned(
            left: 0,
            child: CupertinoButton(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: leftIcon == null ? Container() : leftIcon,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute<void>(
                      builder: (context) {
                        return leftAction;
                      },
                    ),
                  );
                }
            ),
          ),
          Positioned(
            right: 0,
            child: CupertinoButton(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: rightIcon == null ? Container() : rightIcon,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute<void>(
                    builder: (context) {
                      return rightAction;
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

