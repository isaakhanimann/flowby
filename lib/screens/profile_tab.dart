import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/edit_profile_screen.dart';
import 'package:Flowby/screens/settings_screen.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/widgets/listview_of_user_infos.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:Flowby/widgets/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';

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
              child: SizedBox(
                width: 200,
                child: FlareActor(
                  'assets/animations/liquid_loader.flr',
                  alignment: Alignment.center,
                  color: kDefaultProfilePicColor,
                  fit: BoxFit.contain,
                  animation: "Untitled",
                ),
              ),
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
                          return EditProfileScreen(user: user);
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
                            user: user,
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
