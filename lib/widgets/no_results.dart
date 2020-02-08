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

class NoResults extends StatefulWidget {
  final bool isSkillSelected;
  final String uidOfLoggedInUser;

  NoResults({this.isSkillSelected, this.uidOfLoggedInUser});

  @override
  _NoResultsState createState() => _NoResultsState();
}

class _NoResultsState extends State<NoResults> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      progressIndicator: SizedBox(
        width: 200,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(height: 15.0),
              Image.asset(
                'assets/images/stony_sad.png',
                height: 200,
              ),
              SizedBox(height: 15.0),
              widget.isSkillSelected
                  ? Text(
                      'No user found... add this skill as a wish so skilled people can find you',
                      style: kAddSkillsTextStyle,
                      textAlign: TextAlign.center,
                    )
                  : Text('No user with this wish found',
                      style: kAddSkillsTextStyle, textAlign: TextAlign.center),
              SizedBox(height: 5.0),
              widget.isSkillSelected
                  ? RoundedButton(
                      text: 'Add skill',
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
                      text: 'Help us spread the word',
                      textColor: Colors.white,
                      color: kBlueButtonColor,
                      onPressed: () => Share.share(
                          'Flowby is a skill-sharing community where you meet people nearby you to learn new skills. The more, the merrier and the more skills. Join the adventure: https://flowby.app/'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
