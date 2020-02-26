import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/edit_profile_screen.dart';
import 'package:Flowby/screens/settings_screen.dart';
import 'package:Flowby/widgets/listview_of_user_infos.dart';
import 'package:Flowby/widgets/tab_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
            child: Stack(alignment: Alignment.topCenter, children: <Widget>[
              ListViewOfUserInfos(user: user, isProfileTab: true),
              Positioned(
                child: TabHeader(
                  leftIcon: Icon(Feather.settings),
                  leftAction: SettingsScreen(user: user),
                  rightIcon: Icon(Feather.edit),
                  rightAction: EditProfileScreen(user: user),
                ),
              ),
            ]),
          );
        });
  }
}
