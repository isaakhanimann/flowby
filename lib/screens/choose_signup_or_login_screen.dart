import 'package:Flowby/screens/signin_tab.dart';
import 'package:flutter/cupertino.dart';

class ChooseSignupOrLoginScreen extends StatelessWidget {
  static const String id = 'ChooseSignupOrLoginScreen';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.white, child: SigninTab());
  }
}
