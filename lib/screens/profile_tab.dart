import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/edit_profile_screen.dart';
import 'package:float/screens/settings_screen.dart';
import 'package:float/services/firebase_cloud_firestore_service.dart';
import 'package:float/widgets/listview_of_user_infos.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:float/widgets/sign_in_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<FirebaseUser>(context, listen: false);
    if (loggedInUser == null) {
      return Center(child: SignInButton());
    }
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    return FutureBuilder(
        future: cloudFirestoreService.getUser(uid: loggedInUser.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
          User user = snapshot.data;

          return SafeArea(
            bottom: false,
            child: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
              ListViewOfUserInfos(user: user),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: RoundedButton(
                  text: 'Edit your profile',
                  color: ffDarkBlue,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute<void>(
                        builder: (context) {
                          return EditProfileScreen(loggedInUser: loggedInUser);
                        },
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: CupertinoButton(
                  child: Icon(
                    Feather.settings,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute<void>(
                        builder: (context) {
                          return SettingsScreen(
                            loggedInUser: loggedInUser,
                          );
                        },
                      ),
                    );
                  },
                ),
              )
            ]),
          );
        });
  }
}
