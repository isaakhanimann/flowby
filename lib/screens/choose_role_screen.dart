import 'package:Flowby/constants.dart';
import 'package:Flowby/screens/navigation_screen.dart';
import 'package:Flowby/widgets/centered_loading_indicator.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/services/preferences_service.dart';
import 'package:Flowby/models/role.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/models/user.dart';

class ChooseRoleScreen extends StatefulWidget {
  @override
  _ChooseRoleScreenState createState() => _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends State<ChooseRoleScreen> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    User loggedInUser = Provider.of<User>(context);

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      progressIndicator: CenteredLoadingIndicator(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        color: CupertinoColors.activeOrange,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Do you want to search for skills or provide some?',
              style: kExplanationTitleTextStyle,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 1 / 5,
            ),
            RoundedButton(
                color: kBlueButtonColor,
                textColor: CupertinoColors.white,
                onPressed: () {
                  Role role = Role.consumer;
                  _setRoleAndNavigate(
                      context: context, role: role, user: loggedInUser);
                },
                text: 'Search'),
            RoundedButton(
                color: kBlueButtonColor,
                textColor: CupertinoColors.white,
                onPressed: () {
                  Role role = Role.provider;
                  _setRoleAndNavigate(
                      context: context, role: role, user: loggedInUser);
                },
                text: 'Provide')
          ],
        ),
      ),
    );
  }

  _setRoleAndNavigate({BuildContext context, Role role, User user}) async {
    setState(() {
      showSpinner = true;
    });
    final preferencesService =
        Provider.of<PreferencesService>(context, listen: false);
    await preferencesService.setRole(role: role);

    if (user != null) {
      final cloudFirestoreService =
          Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
      await cloudFirestoreService.uploadUsersRole(uid: user.uid, role: role);
    }

    setState(() {
      showSpinner = false;
    });
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute<void>(
        builder: (context) {
          return NavigationScreen();
        },
      ),
    );
  }
}
