import 'package:float/models/user.dart';
import 'package:float/widgets/list_of_profiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StreambuilderWithLoadingIndicator extends StatelessWidget {
  final Stream<List<User>> userStream;
  final bool searchSkill;
  final bool showProfiles;

  StreambuilderWithLoadingIndicator(
      {@required this.userStream,
      @required this.showProfiles,
      this.searchSkill = true});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: userStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Expanded(
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }
        List<User> users = List.from(snapshot.data);
        print(
            '**********************************users = $users'); // to convert it editable list
        users.sort((user1, user2) =>
            (user1.distanceInKm ?? 1000).compareTo(user2.distanceInKm ?? 1000));
        return Expanded(
            child: ListOfProfiles(users: users, searchSkill: searchSkill));
      },
    );
  }
}
