import 'package:float/screens/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:float/constants.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:float/widgets/rate_picker.dart';

class AddWishesRegistrationScreen extends StatefulWidget {
  static const String id = 'add_whishes_registration_screen';

  @override
  _AddWishesRegistrationScreenState createState() =>
      _AddWishesRegistrationScreenState();
}

class _AddWishesRegistrationScreenState
    extends State<AddWishesRegistrationScreen> {
  bool showSpinner = false;

  int _databaseWishRate;
  int _localWishRate;
  String _databaseHashtagWishes;
  String _localHashtagWishes;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.colorBurn),
          image: AssetImage("images/Freeflowter_Stony.png"),
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        width: 20.0,
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 5, color: Colors.blueAccent)),
                        child: Text("My Awesome Border"),
                      ),
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
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Your wishes (e.g. #sushis)',
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: TextStyle(fontFamily: 'MontserratRegular'),
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
                        initialValue: _localWishRate ?? 20,
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

                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute<void>(
                              builder: (context) {
                                return NavigationScreen();
                              },
                            ),
                          );

                          setState(() {
                            showSpinner = false;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute<void>(
                              builder: (context) {
                                return NavigationScreen();
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
            ),
          ),
        ),
      ),
    );
  }
}
