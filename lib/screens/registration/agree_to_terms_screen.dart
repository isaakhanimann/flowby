import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/screens/navigation_screen.dart';
import 'package:Flowby/widgets/centered_loading_indicator.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'add_image_username_and_bio_registration_screen.dart';
import 'package:Flowby/widgets/custom_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';

class AgreeToTermsScreen extends StatefulWidget {
  final User user;
  final bool nextScreenIsNavigationScreen;

  AgreeToTermsScreen(
      {@required this.user, this.nextScreenIsNavigationScreen = false});

  @override
  _AgreeToTermsScreenState createState() => _AgreeToTermsScreenState();
}

class _AgreeToTermsScreenState extends State<AgreeToTermsScreen> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      progressIndicator: CenteredLoadingIndicator(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        color: CupertinoColors.white,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context).translate("please_agree_to_terms"),
                style: kExplanationTitleTextStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 12,
              ),
              TermsItem(
                text: AppLocalizations.of(context)
                    .translate('terms_and_conditions'),
                urlToGoTo: 'https://flowby.co/terms-and-conditions.pdf',
              ),
              TermsItem(
                text: AppLocalizations.of(context).translate('privacy_policy'),
                urlToGoTo: 'https://flowby.co/privacy-policy.pdf',
              ),
              TermsItem(
                text: AppLocalizations.of(context)
                    .translate('acceptable_use_policy'),
                urlToGoTo: 'https://flowby.co/acceptable-use-policy.pdf',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 12,
              ),
              RoundedButton(
                color: kBlueButtonColor,
                textColor: CupertinoColors.white,
                onPressed: () {
                  _agreeAndNavigate(context);
                },
                text: AppLocalizations.of(context)
                    .translate("agree_and_continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _agreeAndNavigate(BuildContext context) async {
    setState(() {
      showSpinner = true;
    });
    widget.user.hasAgreedToTerms = true;

    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    await cloudFirestoreService.uploadUser(user: widget.user);
    setState(() {
      showSpinner = false;
    });
    if (widget.nextScreenIsNavigationScreen) {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        CupertinoPageRoute(
            builder: (BuildContext context) => NavigationScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        CupertinoPageRoute(
            builder: (BuildContext context) =>
                AddImageUsernameAndBioRegistrationScreen(user: widget.user)),
        (Route<dynamic> route) => false,
      );
    }
  }
}

class TermsItem extends StatelessWidget {
  final String text;
  final String urlToGoTo;

  TermsItem({@required this.text, this.urlToGoTo});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      leading: SizedBox(
        width: 30,
      ),
      middle: Text(
        text,
        style: kSettingsTextStyle,
        textAlign: TextAlign.center,
      ),
      onPress: _launchURL,
      paddingInsideVertical: 20,
    );
  }

  _launchURL() async {
    if (await canLaunch(urlToGoTo)) {
      await launch(urlToGoTo);
    } else {
      throw 'Could not launch $urlToGoTo';
    }
  }
}
