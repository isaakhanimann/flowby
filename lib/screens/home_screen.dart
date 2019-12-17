import 'package:float/constants.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:float/widgets/stream_list_users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<bool> _selections = [true, false];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ToggleButtons(
          isSelected: _selections,
          onPressed: (index) {
            setState(() {
              _selections[index] = !_selections[index];
              int otherIndex = (index + 1) % 2;
              _selections[otherIndex] = !_selections[otherIndex];
            });
          },
          selectedColor: kDarkGreenColor,
          fillColor: Colors.transparent,
          selectedBorderColor: kDarkGreenColor,
          borderColor: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Text('Skills'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Text('Wishes'),
            ),
          ],
        ),
        StreamListUsers(
          userStream: FirebaseConnection.getUsersStream(),
          searchSkill: _selections[0],
        ),
      ],
    );
  }
}
