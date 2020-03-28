import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/screens/edit_profile_screen.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/models/user.dart';
import 'package:share/share.dart';
import '../constants.dart';
import 'package:Flowby/widgets/centered_loading_indicator.dart';
import 'package:Flowby/models/search_mode.dart';

class NoResults extends StatefulWidget {
  final String uidOfLoggedInUser;

  NoResults({this.uidOfLoggedInUser});

  @override
  _NoResultsState createState() => _NoResultsState();
}

class _NoResultsState extends State<NoResults> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    final searchMode = Provider.of<SearchMode>(context, listen: false);
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      progressIndicator: SizedBox(
        width: 200,
        child: CenteredLoadingIndicator(),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 15.0),
                Image.asset(
                  'assets/images/stony_sad.png',
                  height: 200,
                ),
                SizedBox(height: 15.0),
                (searchMode.mode == Mode.searchSkills)
                    ? Text(
                        AppLocalizations.of(context)
                            .translate('no_user_found_1'),
                        style: kAddSkillsTextStyle,
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        AppLocalizations.of(context)
                            .translate('no_user_found_2'),
                        style: kAddSkillsTextStyle,
                        textAlign: TextAlign.center,
                      ),
                SizedBox(height: 5.0),
                (searchMode.mode == Mode.searchSkills)
                    ? RoundedButton(
                        text:
                            AppLocalizations.of(context).translate('add_wish'),
                        textColor: Colors.white,
                        color: kBlueButtonColor,
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });

                          User user = await cloudFirestoreService.getUser(
                              uid: widget.uidOfLoggedInUser);

                          setState(() {
                            showSpinner = false;
                          });

                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute<void>(
                              builder: (context) {
                                return EditProfileScreen(
                                  user: user,
                                );
                              },
                            ),
                          );
                        })
                    : RoundedButton(
                        text: AppLocalizations.of(context)
                            .translate('invite_friend'),
                        paddingInsideHorizontal: 39,
                        textColor: Colors.white,
                        color: kBlueButtonColor,
                        onPressed: () => Share.share(
                            AppLocalizations.of(context)
                                .translate('flowby_is')),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
