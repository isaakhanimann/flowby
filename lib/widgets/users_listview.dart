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
    return ListView.builder(
      itemBuilder: (context, index) {
        return ProfileItem(
          user: users[index],
          isSkillSearch: searchSkill,
        );
      },
      itemCount: users.length,
    );
  }
}
