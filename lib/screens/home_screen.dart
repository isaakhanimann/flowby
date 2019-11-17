import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:float/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:float/widgets/hashtag_bubble.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'create_profile_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseConnection connection = FirebaseConnection();

  FirebaseUser loggedInUser;

  Future<String> _getAndSetLoggedInUser() async {
    loggedInUser = await connection.getCurrentUser();
    return loggedInUser.email;
  }

  @override
  void initState() {
    super.initState();
    _getAndSetLoggedInUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                connection.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('Home'),
        backgroundColor: kDarkGreenColor,
      ),
      body: Container(),
    );
  }
}
