import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/edit_profile_screen.dart';
import 'package:Flowby/screens/settings_screen.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/widgets/centered_loading_indicator.dart';
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
    final loggedInUser = Provider.of<FirebaseUser>(context, listen: false);

    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    return StreamBuilder(
        stream: cloudFirestoreService.getUserStream(uid: loggedInUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return CenteredLoadingIndicator();
          }

          User user = snapshot.data;

          return SafeArea(
            bottom: false,
            child: Stack(alignment: Alignment.topCenter, children: <Widget>[
              ListViewOfUserInfos(user: user),
              TabHeader(
                leftIcon: Icon(Feather.settings),
                leftAction: SettingsScreen(user: user),
                rightIcon: Icon(Feather.edit),
                rightAction: EditProfileScreen(user: user),
              ),
            ]),
          );
        });
  }
}
