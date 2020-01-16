import 'package:float/screens/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:float/constants.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:float/widgets/rate_picker.dart';
import 'package:float/widgets/progress_bar.dart';
import 'package:float/models/user.dart';

import 'package:float/services/firebase_cloud_firestore_service.dart';
import 'package:float/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  int _databaseWishRate = 20;
  String _databaseHashtagWishes;

  User _user;

  @override
  Widget build(BuildContext context) {
    widget.user != null
        ? _user = widget.user
        : print('Why da fuck is User == NULL?!');

    //print(_user);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.colorBurn),
          image: AssetImage("assets/images/Freeflowter_Stony.png"),
          alignment: Alignment(0.0, 0.0),
          fit: BoxFit.cover,
        ),
      ),
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kDarkGreenColor),
        ),
        child: SafeArea(
          child: Scaffold(
            /*appBar: AppBar(
              title: Text('Upload a picture'),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),*/
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Stack(children: [
                ProgressBar(progress: 1),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Add what you would like to learn',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratRegular',
                            fontSize: 22.0,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            _databaseHashtagWishes = value;
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Your wishes (e.g. #sushis)',
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle:
                                TextStyle(fontFamily: 'MontserratRegular'),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 30.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'How much would you pay?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratRegular',
                            fontSize: 18.0,
                          ),
                        ),
                        RatePicker(
                          initialValue: _databaseWishRate ?? 20,
                          onSelected: (selectedIndex) {
                            _databaseWishRate = selectedIndex;
                          },
                        ),
                        RoundedButton(
                          text: 'I am ready!',
                          color: ffDarkBlue,
                          textColor: Colors.white,
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });

                            _user.wishHashtags = _databaseHashtagWishes;
                            _user.wishRate = _databaseWishRate;

                            final cloudFirestoreService =
                                Provider.of<FirebaseCloudFirestoreService>(
                                    context,
                                    listen: false);

                            await cloudFirestoreService.uploadUser(user: _user);
                            final authService =
                                Provider.of<FirebaseAuthService>(context,
                                    listen: false);

                            await authService.tryToGetCurrentUserAndNavigate(
                                context: context);

                            setState(() {
                              showSpinner = false;
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            final loggedInUser = Provider.of<FirebaseUser>(context, listen: false);

                            Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute<void>(
                                builder: (context) {
                                  return NavigationScreen(loggedInUser: loggedInUser);
                                },
                              ),
                            );
                          },
                          child: Text(
                            'Skip this step',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'MontserratRegular',
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        /*
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'We all have at least a valuable skill',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratRegular',
                            fontSize: 22.0,
                          ),
                        ),
                        Container(
                          height: 350.0,
                          width: 350.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.white, BlendMode.colorBurn),
                              image: AssetImage("images/Freeflowter_Stony.png"),
                              alignment: Alignment(0.0, 0.0),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),*/
                      ]),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
