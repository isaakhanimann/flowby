import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/screens/chat_overview_screen.dart';
import 'package:float/screens/create_profile_screen.dart';
import 'package:float/screens/home_screen.dart';
import 'package:float/services/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationScreen extends StatefulWidget {
  static const String id = 'navigation_screen';

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<Widget> tabScreens = [
    HomeScreen(),
    ChatOverviewScreen(),
    CreateProfileScreen()
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var loggedInUser = Provider.of<FirebaseUser>(context);
    if (loggedInUser != null) {
      Location.getLastKnownPositionAndUploadIt(userEmail: loggedInUser.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
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
          return tabScreens[index];
        });
      },
    );
  }
}
