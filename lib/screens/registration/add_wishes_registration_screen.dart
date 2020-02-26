import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/navigation_screen.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/widgets/list_of_textfields.dart';
import 'package:Flowby/widgets/progress_bar.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class AddWishesRegistrationScreen extends StatefulWidget {
  static const String id = 'add_whishes_registration_screen';

  final User user;

  AddWishesRegistrationScreen({this.user});

  @override
  _AddWishesRegistrationScreenState createState() =>
      _AddWishesRegistrationScreenState();
}

class _AddWishesRegistrationScreenState
    extends State<AddWishesRegistrationScreen> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Stack(children: [
              Hero(
                child: ProgressBar(progress: 1),
                transitionOnUserGestures: true,
                tag: 'progress_bar',
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Your wishes',
                        style: kUsernameTitleTextStyle,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Tell others what you would like to learn',
                            textAlign: TextAlign.start,
                            style: kRegisterHeaderTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          ListOfTextfields(
                              key: UniqueKey(),
                              initialSkillsOrWishes: widget.user.wishes,
                              updateKeywordsAtIndex:
                                  widget.user.updateWishKeywordsAtIndex,
                              updateDescriptionAtIndex:
                                  widget.user.updateWishDescriptionAtIndex,
                              updatePriceAtIndex:
                                  widget.user.updateWishPriceAtIndex,
                              addEmptySkillOrWish: widget.user.addEmptyWish,
                              deleteSkillOrWishAtIndex:
                                  widget.user.deleteWishAtIndex),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                      RoundedButton(
                        text: 'I am ready!',
                        color: kBlueButtonColor,
                        textColor: Colors.white,
                        onPressed: () {
                          _uploadUserAndNavigate(context);
                        },
                      ),
                    ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _uploadUserAndNavigate(BuildContext context) async {
    setState(() {
      showSpinner = true;
    });

    widget.user.wishes.removeWhere(
        (wish) => (wish.keywords == null || wish.keywords.isEmpty));
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    await cloudFirestoreService.uploadUser(user: widget.user);
    setState(() {
      showSpinner = false;
    });

    Navigator.of(context).pushNamedAndRemoveUntil(
      NavigationScreen.id,
      (Route<dynamic> route) => false,
    );
  }
}
