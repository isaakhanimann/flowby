import 'package:flutter/cupertino.dart';

// like a listtile but for ios, should be used for profiles, chats and settings

class ClickableListItem extends StatelessWidget {
  final Function onTap;
  final Widget left;
  final Widget middle;
  final Widget right;

  ClickableListItem({@required this.onTap, this.left, this.middle, this.right});
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          left,
          Expanded(child: middle),
          right,
          Icon(CupertinoIcons.right_chevron)
        ],
      ),
      onPressed: () {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text('Card is clicked.'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('ok'),
                onPressed: () {
                  Navigator.pop(context, 'ok');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
