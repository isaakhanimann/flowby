import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/widgets/profile_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StreamListUsers extends StatelessWidget {
  final Stream<List<User>> userStream;

  StreamListUsers({@required this.userStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: userStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Expanded(
            child: Center(
              child: SpinKitPumpingHeart(
                color: kDarkGreenColor,
                size: 100,
              ),
            ),
          );
        }
        final List<User> users = snapshot.data;
        List<Widget> userWidgets = [];
        for (User user in users) {
          final userWidget = Column(
            children: <Widget>[
              Divider(
                height: 10,
              ),
              ProfileItem(
                user: user,
              )
            ],
          );
          userWidgets.add(userWidget);
        }
        return Expanded(
          child: ListView(
            children: userWidgets,
          ),
        );
      },
    );
  }
}
