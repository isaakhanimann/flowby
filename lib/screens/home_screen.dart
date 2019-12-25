import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/models/user.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:float/widgets/stream_list_users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';
  final Function switchSearch;
  final isSkillSelected;
  HomeScreen({@required this.isSkillSelected, @required this.switchSearch});

  @override
  Widget build(BuildContext context) {
    var loggedInUser = Provider.of<FirebaseUser>(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            CupertinoSegmentedControl(
              groupValue: isSkillSelected,
              onValueChanged: switchSearch,
              children: <bool, Widget>{
                true: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  child: Text('Skills', style: TextStyle(fontSize: 18)),
                ),
                false: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  child: Text('Wishes', style: TextStyle(fontSize: 18)),
                ),
              },
            ),
            SizedBox(height: 10),
            StreamBuilder(
              stream: FirebaseConnection.getUserStream(uid: loggedInUser.email),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(color: Colors.white);
                }
                User user = snapshot.data;
                return StreamListUsers(
                  userStream: FirebaseConnection.getUsersStreamWithDistance(
                      loggedInUser: user),
                  searchSkill: isSkillSelected,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
