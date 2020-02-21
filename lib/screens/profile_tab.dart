import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/edit_profile_screen.dart';
import 'package:Flowby/screens/settings_screen.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/widgets/listview_of_user_infos.dart';
import 'package:Flowby/widgets/rounded_button.dart';
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
            return Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
              ),
            );
          }

          User user = snapshot.data;

          return SafeArea(
            bottom: false,
            child: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
              ListViewOfUserInfos(user: user),
              Positioned(
                bottom: 20,
                child: RoundedButton(
                  text: 'Edit your profile',
                  color: kBlueButtonColor,
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
