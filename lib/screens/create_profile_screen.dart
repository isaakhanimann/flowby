import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:float/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:float/widgets/hashtag_bubble.dart';
import 'package:float/services/firebase_connection.dart';

class CreateProfileScreen extends StatefulWidget {
  static const String id = 'create_profile_screen';

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final userController = TextEditingController();

  FirebaseConnection connection = FirebaseConnection();

  String _hashtagSkills = '';
  String _tempHashtagSkills = '';
  String _hashtagWishes = '';
  String _tempHashtagWishes = '';
  File _profilePic;
  String _profilePicUrl;
  FirebaseUser loggedInUser;

  void changeProfilePic() async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('Take Photo'),
              onPressed: () {
                Navigator.pop(context);
                _setImage(ImageSource.camera);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Choose Photo'),
              onPressed: () {
                Navigator.pop(context);
                _setImage(ImageSource.gallery);
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancel'),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
    );
  }

  void _setImage(ImageSource source) async {
    var selectedImage = await ImagePicker.pickImage(source: source);
    setState(() {
      _profilePic = selectedImage;
    });
  }

  void _setLoggedInUser() async {
    loggedInUser = await connection.getCurrentUser();
  }

  void _setUserFromFirebaseData() async {
    var userMap = await connection.getUserInfos(userID: 'isaak');
    //also fill the temps in case the user presses save and the messageboxes are filled
    setState(() {
      _hashtagSkills = userMap['supplyHashtags'];
      _tempHashtagSkills = _hashtagSkills;
      _hashtagWishes = userMap['demandHashtags'];
      _tempHashtagWishes = _hashtagWishes;
    });
  }

  void _setImageFromFirebaseData() async {
    String imgUrl = await connection.getImageUrl(fileName: 'isaak');
    //also fill the temps in case the user presses save and the messageboxes are filled
    setState(() {
      _profilePicUrl = imgUrl;
      _profilePic = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _setLoggedInUser();
    _setImageFromFirebaseData();
    _setUserFromFirebaseData();
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
        title: Text('Create Profile'),
        backgroundColor: kDarkGreenColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: changeProfilePic,
              child: Center(
                child: _profilePic == null
                    ? _profilePicUrl == null
                        ? CircleAvatar(
                            backgroundImage:
                                AssetImage('images/default-profile-pic.jpg'),
                            radius: 60,
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(_profilePicUrl),
                            radius: 60,
                          )
                    : CircleAvatar(
                        backgroundImage: FileImage(_profilePic),
                        radius: 60,
                      ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: changeProfilePic,
              child: Text('Edit'),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Add skills',
              style: kTitleTextStyle,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Add your skills in hashtags so people can find you',
            ),
            SizedBox(
              height: 5,
            ),
            _hashtagSkills == ''
                ? TextFormField(
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kDarkGreenColor),
                    onChanged: (newValue) {
                      setState(() {
                        _tempHashtagSkills = newValue;
                      });
                    },
                  )
                : HashtagBubble(
                    text: _hashtagSkills,
                    onPress: () {
                      setState(() {
                        _hashtagSkills = '';
                        _tempHashtagSkills = '';
                      });
                    },
                  ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Add wishes',
              style: kTitleTextStyle,
            ),
            Text(
              'Add hashtags to let people know what they can help you with',
            ),
            SizedBox(
              height: 5,
            ),
            _hashtagWishes == ''
                ? TextFormField(
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kDarkGreenColor),
                    onChanged: (newValue) {
                      setState(() {
                        _tempHashtagWishes = newValue;
                      });
                    },
                  )
                : HashtagBubble(
                    text: _hashtagWishes,
                    onPress: () {
                      setState(() {
                        _hashtagWishes = '';
                        _tempHashtagWishes = '';
                      });
                    },
                  ),
            SizedBox(
              height: 5,
            ),
            RoundedButton(
              text: 'Save',
              color: kDarkGreenColor,
              onPressed: () {
                if (_profilePic != null) {
                  connection.uploadImage(fileName: 'isaak', image: _profilePic);
                }
                connection.uploadUserInfos(
                    userID: 'isaak',
                    email: loggedInUser.email,
                    hashtagSkills: _tempHashtagSkills,
                    hashtagWishes: _tempHashtagWishes);
                _setUserFromFirebaseData();
              },
            ),
          ],
        ),
      ),
    );
  }
}
