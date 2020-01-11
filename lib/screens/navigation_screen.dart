import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/screens/chat_overview_screen.dart';
import 'package:float/screens/home_screen.dart';
import 'package:float/screens/settings_screen.dart';
import 'package:float/services/firebase_cloud_firestore_service.dart';
import 'package:float/services/location_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class NavigationScreen extends StatefulWidget {
  static const String id = 'navigation_screen';

  final loggedInUser;

  NavigationScreen({@required this.loggedInUser});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  Stream<Position> positionStream;
  StreamSubscription<Position> positionStreamSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //upload the users location whenever it changes
    if (widget.loggedInUser != null) {
      final cloudFirestoreService =
          Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
      final locationService =
          Provider.of<LocationService>(context, listen: false);
      //asBroadcast because the streamprovider for the homescreen also listens to it
      positionStream = locationService.getPositionStream().asBroadcastStream();
      positionStreamSubscription = positionStream.listen((Position position) {
        cloudFirestoreService.uploadUsersLocation(
            uid: widget.loggedInUser.uid, position: position);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    positionStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Position>.value(
          value: positionStream,
        ),
        Provider<FirebaseUser>.value(
          value: widget.loggedInUser,
        ),
      ],
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          activeColor: kDarkGreenColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.home,
                ),
                title: Text('Home')),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.conversation_bubble,
              ),
              title: Text('Messages'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.person,
              ),
              title: Text('Profile'),
            ),
          ],
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(builder: (context) {
            switch (index) {
              case 0:
                return HomeScreen();
              case 1:
                return ChatOverviewScreen();
              case 2:
                return SettingsScreen();
              default:
                return Container(color: Colors.red);
            }
          });
        },
      ),
    );
  }
}
