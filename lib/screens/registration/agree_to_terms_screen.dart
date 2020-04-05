import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'add_image_username_and_bio_registration_screen.dart';
import 'package:Flowby/widgets/custom_card.dart';
import 'package:url_launcher/url_launcher.dart';

class AgreeToTermsScreen extends StatelessWidget {
  final User user;

  AgreeToTermsScreen({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: double.infinity,
      color: CupertinoColors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 10,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "Please agree to the following terms:",
                style: kExplanationMiddleTextStyle,
                textAlign: TextAlign.center,
              ),
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
            Expanded(
              flex: 3,
              child: RoundedButton(
                color: kBlueButtonColor,
                textColor: CupertinoColors.white,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    CupertinoPageRoute(
                        builder: (BuildContext context) =>
                            AddImageUsernameAndBioRegistrationScreen(
                                user: user)),
                    (Route<dynamic> route) => false,
                  );
                },
                text: "Agree and Continue",
              ),
            ),
          ],
        ),
      ),
    );
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
