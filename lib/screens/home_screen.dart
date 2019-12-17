import 'package:float/constants.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:float/widgets/stream_list_users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';
  final List<bool> selections;
  final Function changeSearch;
  HomeScreen({@required this.selections, @required this.changeSearch});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ToggleButtons(
          isSelected: selections,
          onPressed: changeSearch,
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
          searchSkill: selections[0],
        ),
      ],
    );
  }
}
