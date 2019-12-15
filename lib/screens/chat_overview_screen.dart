import 'package:firebase_auth/firebase_auth.dart';
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
    print('loggedInUser = $loggedInUser');
    return FutureBuilder(
        future: FirebaseConnection.getUidOfChatUsers(
            loggedInUser: loggedInUser.email),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(color: Colors.white);
          }
          List<String> uids = snapshot.data;

          print('uids = $uids');

          return Column(
            children: <Widget>[
              StreamListUsers(
                  userStream:
                      FirebaseConnection.getSpecifiedUsersStream(uids: uids)),
            ],
          );
        });
  }
}
