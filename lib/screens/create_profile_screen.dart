import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/choose_signup_or_login_screen.dart';
import 'package:float/services/firebase_auth_service.dart';
import 'package:float/services/firebase_cloud_firestore_service.dart';
import 'package:float/services/firebase_storage_service.dart';
import 'package:float/widgets/hashtag_bubble.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateProfileScreen extends StatefulWidget {
  static const String id = 'create_profile_screen';

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  String _databaseUsername;
  String _localUsername;
  String _databaseHashtagSkills;
  String _localHashtagSkills;
  String _databaseHashtagWishes;
  String _localHashtagWishes;
  File _profilePic;
  String _profilePicUrl;
  FirebaseUser loggedInUser;
  int _databaseSkillRate;
  int _databaseWishRate;
  int _localSkillRate;
  int _localWishRate;
  bool showSpinner = true;

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
    var selectedImage =
        await ImagePicker.pickImage(source: source, imageQuality: 25);
    setState(() {
      _profilePic = selectedImage;
    });
  }

  void _reloadUserFromDatabase(BuildContext context) async {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    User user = await cloudFirestoreService.getUser(uid: loggedInUser.uid);
    //also fill the temps in case the user presses save and the messageboxes are filled
    setState(() {
      _databaseUsername = user?.username;
      _localUsername = _databaseUsername;
      _databaseHashtagSkills = user?.skillHashtags;
      _localHashtagSkills = _databaseHashtagSkills;
      _databaseHashtagWishes = user?.wishHashtags;
      _localHashtagWishes = _databaseHashtagWishes;
      _localSkillRate = user?.skillRate;
      _localWishRate = user?.wishRate;
      _databaseSkillRate = _localSkillRate;
      _databaseWishRate = _localWishRate;
    });
  }

  void _getAndSetData(BuildContext context) async {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    final storageService =
        Provider.of<FirebaseStorageService>(context, listen: false);
    final loggedInUser = Provider.of<FirebaseUser>(context, listen: false);
    String uid = loggedInUser.uid;
    String imgUrl = await storageService.getImageUrl(fileName: uid);
    User user = await cloudFirestoreService.getUser(uid: uid);
    //also fill the temps in case the user presses save and the messageboxes are filled
    setState(() {
      _databaseUsername = user?.username;
      _localUsername = _databaseUsername;
      _databaseHashtagSkills = user?.skillHashtags;
      _localHashtagSkills = _databaseHashtagSkills;
      _databaseHashtagWishes = user?.wishHashtags;
      _localHashtagWishes = _databaseHashtagWishes;
      _localSkillRate = user?.skillRate;
      _localWishRate = user?.wishRate;
      _databaseSkillRate = _localSkillRate;
      _databaseWishRate = _localWishRate;
      _profilePicUrl = imgUrl;
      _profilePic = null;
      showSpinner = false;
    });
  }

  @override
  void initState() {
    super.initState();
    //this is an asynchronous method
    _getAndSetData(context);
  }

  @override
  Widget build(BuildContext context) {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    final storageService =
        Provider.of<FirebaseStorageService>(context, listen: false);

    final loggedInUser = Provider.of<FirebaseUser>(context, listen: false);
    if (loggedInUser == null) {
      return Center(
        child: RoundedButton(
          text: 'Signin',
          color: kDarkGreenColor,
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<void>(
                builder: (context) {
                  return ChooseSignupOrLoginScreen();
                },
              ),
            );
          },
        ),
      );
    }

    if (showSpinner) {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  children: <Widget>[
                    GestureDetector(
                      onTap: changeProfilePic,
                      child: Center(
                        heightFactor: 1.2,
                        child: _profilePic == null
                            ? _profilePicUrl == null
                                ? CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: AssetImage(
                                        'images/default-profile-pic.jpg'),
                                    radius: 60,
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage:
                                        NetworkImage(_profilePicUrl),
                                    radius: 60,
                                  )
                            : CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: FileImage(_profilePic),
                                radius: 60,
                              ),
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: changeProfilePic,
                        child: Text('Edit'),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: _databaseUsername == null
                          ? TextFormField(
                              textAlign: TextAlign.center,
                              style: kMiddleTitleTextStyle,
                              onChanged: (newValue) {
                                setState(() {
                                  _localUsername = newValue;
                                });
                              },
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  _databaseUsername = null;
                                });
                              },
                              child: Text(
                                _databaseUsername,
                                style: kBigTitleTextStyle,
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Add skills',
                      style: kMiddleTitleTextStyle,
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
                    _databaseHashtagSkills == null
                        ? TextFormField(
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kDarkGreenColor),
                            onChanged: (newValue) {
                              setState(() {
                                _localHashtagSkills = newValue;
                              });
                            },
                          )
                        : HashtagBubble(
                            text: _databaseHashtagSkills,
                            onPress: () {
                              setState(() {
                                _databaseHashtagSkills = null;
                                _localHashtagSkills = null;
                              });
                            },
                          ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Add your hourly rate',
                      style: kSmallTitleTextStyle,
                    ),
                    RatePicker(
                      initialValue: _localSkillRate ?? 20,
                      onSelected: (selectedIndex) {
                        _databaseSkillRate = selectedIndex;
                      },
                    ),
                    Text(
                      'Add wishes',
                      style: kMiddleTitleTextStyle,
                    ),
                    Text(
                      'Add hashtags to let people know what they can help you with',
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    _databaseHashtagWishes == null
                        ? TextFormField(
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kDarkGreenColor),
                            onChanged: (newValue) {
                              setState(() {
                                _localHashtagWishes = newValue;
                              });
                            },
                          )
                        : HashtagBubble(
                            text: _databaseHashtagWishes,
                            onPress: () {
                              setState(() {
                                _databaseHashtagWishes = null;
                                _localHashtagWishes = null;
                              });
                            },
                          ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Add maximum you would be willing to pay',
                      style: kSmallTitleTextStyle,
                    ),
                    RatePicker(
                      initialValue: _localWishRate ?? 20,
                      onSelected: (selectedIndex) {
                        _databaseWishRate = selectedIndex;
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
            RoundedButton(
              text: 'Save',
              color: kDarkGreenColor,
              onPressed: () async {
                setState(() {
                  showSpinner = true;
                });
                try {
                  if (_profilePic != null) {
                    await storageService.uploadImage(
                        fileName: loggedInUser.uid, image: _profilePic);
                  }
                  User user = User(
                      username: _localUsername,
                      uid: loggedInUser.uid,
                      skillHashtags: _localHashtagSkills,
                      wishHashtags: _localHashtagWishes,
                      skillRate: _databaseSkillRate,
                      wishRate: _databaseWishRate,
                      imageFileName: loggedInUser.uid);
                  await cloudFirestoreService.uploadUser(user: user);
                  _reloadUserFromDatabase(context);
                } catch (e) {
                  print('Could not upload and get on Save');
                }
                setState(() {
                  showSpinner = false;
                });
              },
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () async {
                final authService = Provider.of<FirebaseAuthService>(context);
                await authService.signOut();
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute<void>(
                    builder: (context) {
                      return ChooseSignupOrLoginScreen();
                    },
                  ),
                );
                /*Navigator.of(context).pushNamedAndRemoveUntil(
                    SplashScreen.id,
                        (Route<dynamic> route) => false);
                        */
              },
              child: Text('Sign Out'),
            )
          ],
        ),
      ),
    );
  }
}

class RatePicker extends StatelessWidget {
  final Function onSelected;
  final int initialValue;
  RatePicker({@required this.onSelected, this.initialValue});

  List<Text> _getPickerItems() {
    List<Text> textList = [];
    for (int i = 0; i < 500; i++) {
      textList.add(Text(i.toString()));
    }
    return textList;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 100,
          width: 130,
          alignment: Alignment.center,
          child: CupertinoPicker(
            scrollController:
                FixedExtentScrollController(initialItem: initialValue),
            backgroundColor: Colors.white,
            itemExtent: 32,
            onSelectedItemChanged: onSelected,
            children: _getPickerItems(),
          ),
        ),
        Text(
          'CHF/h',
          style: TextStyle(fontSize: 25),
        ),
      ],
    );
  }
}
