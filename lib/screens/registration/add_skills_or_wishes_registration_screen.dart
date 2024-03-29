import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/registration/enable_notification_screen.dart';
import 'package:Flowby/widgets/create_skills_section.dart';
import 'package:Flowby/widgets/create_wishes_section.dart';
import 'package:Flowby/widgets/progress_bar.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/models/search_mode.dart';

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
  void initState() {
    super.initState();
    final searchMode = Provider.of<SearchMode>(context, listen: false);
    if (searchMode.mode == Mode.searchWishes) {
      widget.user.addEmptySkill();
    } else {
      widget.user.addEmptyWish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchMode = Provider.of<SearchMode>(context, listen: false);
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
                        (searchMode.mode == Mode.searchWishes)
                            ? AppLocalizations.of(context)
                                .translate('your_skills')
                            : AppLocalizations.of(context)
                                .translate('your_wishes'),
                        style: kUsernameTitleTextStyle,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            (searchMode.mode == Mode.searchWishes)
                                ? AppLocalizations.of(context)
                                    .translate('what_you_offer')
                                : AppLocalizations.of(context)
                                    .translate('what_do_you_need'),
                            textAlign: TextAlign.start,
                            style: kRegisterHeaderTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          (searchMode.mode == Mode.searchWishes)
                              ? CreateSkillsSection(
                                  initialSkills: widget.user.skills,
                                  updateKeywordsAtIndex:
                                      widget.user.updateSkillKeywordsAtIndex,
                                  updateDescriptionAtIndex:
                                      widget.user.updateSkillDescriptionAtIndex,
                                  updatePriceAtIndex:
                                      widget.user.updateSkillPriceAtIndex,
                                  addEmptySkill: widget.user.addEmptySkill,
                                  deleteSkillAtIndex:
                                      widget.user.deleteSkillAtIndex,
                                )
                              : CreateWishesSection(
                                  initialWishes: widget.user.wishes,
                                  updateKeywordsAtIndex:
                                      widget.user.updateWishKeywordsAtIndex,
                                  updateDescriptionAtIndex:
                                      widget.user.updateWishDescriptionAtIndex,
                                  updatePriceAtIndex:
                                      widget.user.updateWishPriceAtIndex,
                                  addEmptyWish: widget.user.addEmptyWish,
                                  deleteWishAtIndex:
                                      widget.user.deleteWishAtIndex,
                                ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                      RoundedButton(
                        text: AppLocalizations.of(context).translate('next'),
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

    final searchMode = Provider.of<SearchMode>(context, listen: false);
    if (searchMode.mode == Mode.searchWishes) {
      widget.user?.skills?.removeWhere(
          (skill) => (skill.keywords == null || skill.keywords.isEmpty));
    } else {
      widget.user?.wishes?.removeWhere(
          (wish) => (wish.keywords == null || wish.keywords.isEmpty));
    }

    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    await cloudFirestoreService.uploadUser(user: widget.user);
    setState(() {
      showSpinner = false;
    });
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute<void>(
        builder: (context) {
          return EnableNotificationScreen(
            user: widget.user,
          );
        },
      ),
    );
  }
}
