import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/edit_profile_screen.dart';
import 'package:Flowby/screens/settings_screen.dart';
import 'package:Flowby/widgets/listview_of_user_infos.dart';
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
      child: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
        ListViewOfUserInfos(user: loggedInUser),
        Positioned(
          top: 0,
          right: 0,
          child: CupertinoButton(
            child: Icon(
              Feather.edit,
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute<void>(
                  builder: (context) {
                    return EditProfileScreen(
                      user: loggedInUser,
                    );
                  },
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: CupertinoButton(
            child: Icon(
              Feather.settings,
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute<void>(
                  builder: (context) {
                    return SettingsScreen(
                      user: loggedInUser,
                    );
                  },
                ),
              );
            },
          ),
        )
      ]),
    );
  }
}
