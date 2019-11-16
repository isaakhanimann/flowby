import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:float/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:float/components/rounded_button.dart';

FirebaseUser loggedInUser;
final _fireStore = Firestore.instance;

class CreateProfileScreen extends StatefulWidget {
  static const String id = 'create_profile_screen';

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final userController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final StorageReference _storageReference =
      FirebaseStorage().ref().child('images/isaak');
  String _hashtagSkills = '';
  String _hashtagWishes = '';
  String randomStuff = 'boboboboobo';
  File _profilePic;
  String _profilePicUrl;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

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

  void _uploadImage() async {
    final StorageUploadTask uploadTask = _storageReference.putFile(_profilePic);
    await uploadTask.onComplete;
    print('File Uploaded');
  }

  void _uploadUserInfos() async {
    _fireStore.collection('users').document('isaak').setData({
      'email': loggedInUser.email,
      'supplyHashtags': _hashtagSkills,
      'demandHashtags': _hashtagWishes,
    });
  }

  void _getUserInfos() async {
    try {
      var userDocument =
          await _fireStore.collection('users').document('isaak').get();
      if (userDocument != null) {
        setState(() {
          _hashtagSkills = userDocument.data['supplyHashtags'];
          _hashtagWishes = userDocument.data['demandHashtags'];
        });
        print('This was exeeeeeeeeeeeeeeeecuted successfully');
      }
    } catch (e) {
      print('Eeeeeeeeeeeeeeeerrrroooooooooor occcuuuuuuuuuurred');
    }
  }

  void _getImage() async {
    try {
      final String downloadUrl = await _storageReference.getDownloadURL();
      setState(() {
        _profilePicUrl = downloadUrl;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _getUserInfos();
    _getImage();
  }

  @override
  Widget build(BuildContext context) {
    print(randomStuff);
    print(_hashtagSkills);
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
            TextFormField(
              textAlign: TextAlign.center,
              style: TextStyle(color: kDarkGreenColor),
              initialValue: _hashtagSkills,
              onChanged: (newValue) {
                setState(() {
                  _hashtagSkills = newValue;
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
            TextFormField(
              textAlign: TextAlign.center,
              style: TextStyle(color: kDarkGreenColor),
              initialValue: _hashtagWishes,
              onChanged: (newValue) {
                setState(() {
                  _hashtagWishes = newValue;
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
                _uploadImage();
                _uploadUserInfos();
              },
            ),
            TextFormField(
              textAlign: TextAlign.center,
              style: TextStyle(color: kDarkGreenColor),
              initialValue: randomStuff,
              onChanged: (newValue) {
                setState(() {
                  _hashtagWishes = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
