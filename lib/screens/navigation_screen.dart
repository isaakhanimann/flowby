import 'package:float/constants.dart';
import 'package:float/screens/chat_overview_screen.dart';
import 'package:float/screens/create_profile_screen.dart';
import 'package:float/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  static const String id = 'navigation_screen';

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  bool isSkillSelected = true;
  void switchSearch(var newIsSelected) {
    setState(() {
      isSkillSelected = !isSkillSelected;
    });
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
          switch (index) {
            case 0:
              return HomeScreen(
                  isSkillSelected: isSkillSelected, switchSearch: switchSearch);
              break;
            case 1:
              return ChatOverviewScreen();
              break;
            case 2:
              return CreateProfileScreen();
              break;
          }
          return ChatOverviewScreen();
        });
//to navigate somewhere else do:
//        return CupertinoTabView(
//          builder: (BuildContext context) {
//            return CupertinoPageScaffold(
//              navigationBar: CupertinoNavigationBar(
//                middle: Text('Page 1 of tab $index'),
//              ),
//              child: Center(
//                child: CupertinoButton(
//                  child: const Text('Next page'),
//                  onPressed: () {
//                    Navigator.of(context).push(
//                      CupertinoPageRoute<void>(
//                        builder: (BuildContext context) {
//                          return CupertinoPageScaffold(
//                            navigationBar: CupertinoNavigationBar(
//                              middle: Text('Page 2 of tab $index'),
//                            ),
//                            child: Center(
//                              child: CupertinoButton(
//                                child: const Text('Back'),
//                                onPressed: () {
//                                  Navigator.of(context).pop();
//                                },
//                              ),
//                            ),
//                          );
//                        },
//                      ),
//                    );
//                  },
//                ),
//              ),
//            );
//          },
//        );
      },
    );
  }
}

//
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    var loggedInUser = Provider.of<FirebaseUser>(context);
//    if (loggedInUser != null) {
//      Location.getLastKnownPositionAndUploadIt(userEmail: loggedInUser.email);
//    }
//  }
//
