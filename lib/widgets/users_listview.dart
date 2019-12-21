import 'package:float/models/user.dart';
import 'package:float/widgets/profile_item.dart';
import 'package:flutter/cupertino.dart';

class UsersListView extends StatelessWidget {
  const UsersListView({
    Key key,
    @required this.users,
    @required this.searchSkill,
  }) : super(key: key);

  final List<User> users;
  final bool searchSkill;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: users
          .map<Widget>(
            (user) => Column(
              children: <Widget>[
                ProfileItem(
                  user: user,
                  isSkillSearch: searchSkill,
                )
              ],
            ),
          )
          .toList(),
    );
  }
}
