import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabHeader extends StatelessWidget {
  final Widget leftIcon;
  final Widget leftAction;
  final Widget rightIcon;
  final Widget rightAction;

  TabHeader({
    this.leftIcon,
    this.leftAction,
    this.rightIcon,
    this.rightAction,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(fit: StackFit.expand, children: [
          Image(
            image: AssetImage("assets/images/logo_flowby.png"),
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
