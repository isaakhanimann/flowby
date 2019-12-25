import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/models/user.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:float/widgets/stream_list_users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatOverviewScreen extends StatelessWidget {
  static const String id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    var loggedInUser = Provider.of<FirebaseUser>(context);
    return FutureBuilder(
        future: FirebaseConnection.getUidsOfUsersInChats(
            loggedInUser: loggedInUser.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CupertinoActivityIndicator());
          }
          if (snapshot.hasError) {
            return Container(
              color: Colors.red,
              child: Text('Something went wrong'),
            );
          }
          if (!snapshot.hasData) {
            return Container(color: Colors.white);
          }
          List<String> uids = snapshot.data;
          return Column(
            children: <Widget>[
              //display all users specified with the uids
              StreamBuilder(
                stream: FirebaseConnection.getSpecifiedUserStream(
                    uid: loggedInUser.email),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                        child: Center(child: CupertinoActivityIndicator()));
                  }
                  User user = snapshot.data;
                  return StreamListUsers(
                    userStream:
                        FirebaseConnection.getSpecifiedUsersStreamWithDistance(
                            loggedInUser: user, uids: uids),
                    searchSkill: true,
                  );
                },
              ),
            ],
          );
        });
  }
}
