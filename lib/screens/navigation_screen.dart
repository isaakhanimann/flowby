import 'dart:async';

import 'package:Flowby/constants.dart';
import 'package:Flowby/screens/chats_tab.dart';
import 'package:Flowby/screens/home_tab.dart';
import 'package:Flowby/screens/profile_tab.dart';
import 'package:Flowby/services/firebase_auth_service.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/services/firebase_cloud_messaging.dart';
import 'package:Flowby/services/location_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:Flowby/screens/choose_signin_screen.dart';

class NavigationScreen extends StatefulWidget {
  static const String id = 'navigation_screen';

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  Stream<Position> positionStream;
  StreamSubscription<Position> positionStreamSubscription;
  FirebaseUser loggedInUser;

  @override
  void initState() {
    super.initState();
    final locationService =
        Provider.of<LocationService>(context, listen: false);
    //asBroadcast because the streamprovider for the homescreen also listens to it
    positionStream = locationService.getPositionStream().asBroadcastStream();
    getLoggedInUserUploadLocationAndToken();
  }

  @override
  void dispose() {
    super.dispose();
    if (positionStreamSubscription != null) {
      positionStreamSubscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loggedInUser == null) {
      return MultiProvider(
        providers: [
          StreamProvider<Position>.value(
            value: positionStream,
          ),
          Provider<FirebaseUser>.value(
            value: loggedInUser,
          ),
        ],
        child: CupertinoPageScaffold(
          backgroundColor: CupertinoColors.white,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              HomeTab(),
              Positioned(
                bottom: 50,
                child: RoundedButton(
                  text: 'Sign In',
                  color: kDefaultProfilePicColor,
                  textColor: kBlueButtonColor,
                  onPressed: () async {
                    Navigator.of(context).push(
                      CupertinoPageRoute<void>(
                        builder: (context) {
                          return ChooseSigninScreen(
                            canGoBack: true,
                          );
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    }

    return MultiProvider(
      providers: [
        StreamProvider<Position>.value(
          value: positionStream,
        ),
        Provider<FirebaseUser>.value(
          value: loggedInUser,
        ),
      ],
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Colors.white,
          activeColor: kDefaultProfilePicColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
              Feather.search,
            )),
            BottomNavigationBarItem(
              icon: Icon(
                Feather.mail,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Feather.user,
              ),
            ),
          ],
        ),
        tabBuilder: (context, index) {
          // since every tabview is created new on every call maybe this code can be shorter without side effects
          CupertinoTabView returnValue;
          switch (index) {
            case 0:
              returnValue = CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: HomeTab(),
                );
              });
              break;
            case 1:
              returnValue = CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: ChatsTab(),
                );
              });
              break;
            case 2:
              returnValue = CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: ProfileTab(),
                );
              });
              break;
          }
          return returnValue;
        },
      ),
    );
  }

  Future<void> getLoggedInUserUploadLocationAndToken() async {
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    FirebaseUser user = await authService.getCurrentUser();
    setState(() {
      loggedInUser = user;
    });
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    final firebaseMessaging =
        Provider.of<FirebaseCloudMessaging>(context, listen: false);

    if (loggedInUser != null) {
      positionStreamSubscription = positionStream.listen((Position position) {
        cloudFirestoreService.uploadUsersLocation(
            uid: loggedInUser.uid, position: position);
      });
      firebaseMessaging.firebaseCloudMessagingListeners(context);
      firebaseMessaging.getToken().then((token) {
        cloudFirestoreService.uploadPushToken(
            uid: loggedInUser.uid, pushToken: token);
      });
    }
  }
}
