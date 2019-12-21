import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:float/widgets/stream_list_users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';
  final List<bool> selections;
  final Function changeSearch;
  HomeScreen({@required this.selections, @required this.changeSearch});

  @override
  Widget build(BuildContext context) {
    var loggedInUser = Provider.of<FirebaseUser>(context);

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
        SizedBox(height: 10),
        StreamBuilder(
          stream: FirebaseConnection.getSpecifiedUserStream(
              uid: loggedInUser.email),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(color: Colors.white);
            }
            User user = snapshot.data;
            return StreamListUsers(
              userStream: FirebaseConnection.getUsersStreamWithDistance(
                  loggedInUser: user),
              searchSkill: selections[0],
            );
          },
        ),
      ],
    );
  }
}
