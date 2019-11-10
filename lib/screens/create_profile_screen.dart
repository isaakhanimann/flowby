import 'dart:io';

import 'package:flutter/material.dart';
import 'package:float/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class CreateProfileScreen extends StatefulWidget {
  static const String id = 'create_profile_screen';

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String hashtag = '';
  File _image;

  void getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
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
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Create Profile'),
        backgroundColor: kMiddleGreenColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: getImage,
              child: Center(
                child: _image == null
                    ? CircleAvatar(
                        backgroundImage:
                            AssetImage('images/default-profile-pic.jpg'),
                        radius: 60,
                      )
                    : CircleAvatar(
                        backgroundImage: FileImage(_image),
                        radius: 60,
                      ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: getImage,
              child: Text('Edit'),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Add skills',
              style: TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.w900,
                  color: kDarkGreenColor,
                  letterSpacing: 3.0),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Add your skills in hashtags so people can find you',
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              textAlign: TextAlign.center,
              style: TextStyle(color: kDarkGreenColor),
              onChanged: (newValue) {
                setState(() {
                  hashtag = newValue;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Add wishes',
              style: TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.w900,
                  color: kDarkGreenColor,
                  letterSpacing: 3.0),
            ),
            Text(
              'Add hashtags to let people know what they can help you with',
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
