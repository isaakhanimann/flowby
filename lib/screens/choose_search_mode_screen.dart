import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/constants.dart';
import 'package:Flowby/screens/navigation_screen.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/models/search_mode.dart';

class ChooseSearchModeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final searchMode = Provider.of<SearchMode>(context, listen: false);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: double.infinity,
      color: CupertinoColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('want_search_or_provide'),
            style: kExplanationTitleTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 1 / 5,
          ),
          RoundedButton(
            color: kBlueButtonColor,
            textColor: CupertinoColors.white,
            onPressed: () {
              searchMode.setMode(Mode.searchSkills);
              _navigate(context: context);
            },
            text: AppLocalizations.of(context).translate('search'),
          ),
          RoundedButton(
            color: kBlueButtonColor,
            textColor: CupertinoColors.white,
            onPressed: () {
              searchMode.setMode(Mode.searchWishes);
              _navigate(context: context);
            },
            text: AppLocalizations.of(context).translate('provide'),
          )
        ],
      ),
    );
  }

  _navigate({BuildContext context}) async {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (BuildContext context) => NavigationScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
