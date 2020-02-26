import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/navigation_screen.dart';
import 'package:Flowby/widgets/list_of_textfields.dart';
import 'package:Flowby/widgets/progress_bar.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/models/role.dart';

class AddSkillsOrWishesRegistrationScreen extends StatefulWidget {
  static const String id = 'add_skills_registration_screen';

  final User user;

  AddSkillsOrWishesRegistrationScreen({this.user});

  @override
  _AddSkillsOrWishesRegistrationScreenState createState() =>
      _AddSkillsOrWishesRegistrationScreenState();
}

class _AddSkillsOrWishesRegistrationScreenState
    extends State<AddSkillsOrWishesRegistrationScreen> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    bool isProvider = widget.user.role == Role.provider;
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
                child: ProgressBar(progress: 0.8),
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
                        isProvider ? 'Your skills' : 'Your wishes',
                        style: kUsernameTitleTextStyle,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            isProvider
                                ? 'Share what you are good at'
                                : 'Tell others what you would like to learn',
                            textAlign: TextAlign.start,
                            style: kRegisterHeaderTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          isProvider
                              ? ListOfTextfields(
                                  key: UniqueKey(),
                                  initialSkillsOrWishes: widget.user.skills,
                                  updateKeywordsAtIndex:
                                      widget.user.updateSkillKeywordsAtIndex,
                                  updateDescriptionAtIndex:
                                      widget.user.updateSkillDescriptionAtIndex,
                                  updatePriceAtIndex:
                                      widget.user.updateSkillPriceAtIndex,
                                  addEmptySkillOrWish:
                                      widget.user.addEmptySkill,
                                  deleteSkillOrWishAtIndex:
                                      widget.user.deleteSkillAtIndex,
                                )
                              : ListOfTextfields(
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
                                      widget.user.deleteWishAtIndex,
                                ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                      RoundedButton(
                        text: 'Next',
                        color: kBlueButtonColor,
                        textColor: Colors.white,
                        onPressed: () {
                          _uploadUserAndNavigate(context);
                        },
                      ),
                      Container(
                        height: MediaQuery.of(context).size.width * 0.75,
                        width: MediaQuery.of(context).size.width * 0.75,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.white, BlendMode.colorBurn),
                            image: AssetImage("assets/images/flowby.png"),
                            alignment: Alignment(0.0, 0.0),
                            fit: BoxFit.contain,
                          ),
                        ),
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

    if (widget.user.role == Role.provider && widget.user.skills != null) {
      widget.user.skills.removeWhere(
          (skill) => (skill.keywords == null || skill.keywords.isEmpty));
    } else if (widget.user.role == Role.consumer &&
        widget.user.wishes != null) {
      widget.user.wishes.removeWhere(
          (wish) => (wish.keywords == null || wish.keywords.isEmpty));
    }

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
