import 'package:flutter/material.dart';
import 'package:float/screens/home_screen.dart';
import 'package:float/screens/create_profile_screen.dart';
import 'package:float/constants.dart';

class NavigationScreens extends StatefulWidget {
  static const String id = 'navigation_screen';

  @override
  _NavigationScreensState createState() => _NavigationScreensState();
}

class _NavigationScreensState extends State<NavigationScreens> {
  int _selectedPage = 0;
  final _pageOptions = [CreateProfileScreen(), HomeScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pageOptions[_selectedPage]),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: kDarkGreenColor,
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Profile')),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text('Home')),
        ],
      ),
    );
  }
}
