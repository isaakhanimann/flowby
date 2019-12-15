import 'package:float/services/firebase_connection.dart';
import 'package:float/widgets/stream_list_users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatOverviewScreen extends StatelessWidget {
  static const String id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    return StreamListUsers(userStream: FirebaseConnection.getUsersStream());
  }
}
