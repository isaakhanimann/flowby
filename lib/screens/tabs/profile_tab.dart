import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/edit_profile_screen.dart';
import 'package:Flowby/screens/settings_screen.dart';
import 'package:Flowby/widgets/listview_of_user_infos.dart';
import 'package:Flowby/widgets/tab_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<User>(context);

    return SafeArea(
      bottom: false,
      child: Column(children: <Widget>[
        TabHeader(
          leftIcon: Icon(Feather.settings),
          screenToNavigateToLeft: SettingsScreen(user: loggedInUser),
          rightIcon: Icon(Feather.edit),
          screenToNavigateToRight: EditProfileScreen(user: loggedInUser),
        ),
        Expanded(child: ListViewOfUserInfos(user: loggedInUser)),
      ]),
    );
  }
}
