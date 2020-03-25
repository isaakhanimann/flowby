import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/constants.dart';
import 'package:Flowby/services/firebase_auth_service.dart';
import 'package:Flowby/widgets/login_input_field.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/models/helper_functions.dart';
import 'package:Flowby/widgets/basic_dialog.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String id = 'reset_password_screen';

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String email;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        border: null,
        leading: CupertinoButton(
          child: Icon(CupertinoIcons.back, color: CupertinoColors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        middle: Padding(
          padding: const EdgeInsets.only(top: 13.0),
          child: Text(
            AppLocalizations.of(context).translate('reset_password'),
            style: kCupertinoScaffoldTextStyle,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: kLoginScreenBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 48.0,
              ),
              LoginInputField(
                isLast: false,
                keyboardType: TextInputType.emailAddress,
                placeholder:
                    AppLocalizations.of(context).translate('email_address'),
                setText: (value) {
                  email = value;
                },
              ),
              RoundedButton(
                  color: kBlueButtonColor,
                  textColor: Colors.white,
                  onPressed: () async {
                    final authService = Provider.of<FirebaseAuthService>(
                        context,
                        listen: false);
                    HelperFunctions.showCustomDialog(
                      context: context,
                      dialog: BasicDialog(
                        title: AppLocalizations.of(context)
                            .translate('you_have_mail'),
                        text: AppLocalizations.of(context)
                            .translate('we_sent_mail'),
                      ),
                    );
                    await authService.resetPassword(email: email);
                  },
                  text: AppLocalizations.of(context).translate('send')),
            ],
          ),
        ),
      ),
    );
  }
}
