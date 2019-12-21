import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/widgets/users_listview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StreamListUsers extends StatelessWidget {
  final Stream<List<User>> userStream;
  final bool searchSkill;

  StreamListUsers({@required this.userStream, this.searchSkill = true});

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
        List<User> users = snapshot.data;
        print('users = $users');
//        users.sort((user1, user2) =>
//            (user1.distanceInKm ?? 1000).compareTo(user2.distanceInKm ?? 1000));

        return Expanded(
          child: UsersListView(users: users, searchSkill: searchSkill),
        );
      },
    );
  }
}
