import 'package:Flowby/constants.dart';
import 'package:Flowby/screens/navigation_screen.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/services/preferences_service.dart';

class ChooseRoleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                _setRoleAndNavigate(context: context, role: role);
              },
              text: 'Search'),
          RoundedButton(
              color: kBlueButtonColor,
              textColor: CupertinoColors.white,
              onPressed: () {
                Role role = Role.provider;
                _setRoleAndNavigate(context: context, role: role);
              },
              text: 'Provide')
        ],
      ),
    );
  }

  _setRoleAndNavigate({BuildContext context, Role role}) async {
    final preferencesService =
        Provider.of<PreferencesService>(context, listen: false);
    await preferencesService.setRole(role: role);
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute<void>(
        builder: (context) {
          return NavigationScreen();
        },
      ),
    );
  }
}
