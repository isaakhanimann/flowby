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
import 'package:float/screens/login_screen.dart';

class CreateProfileScreen extends StatefulWidget {
  static const String id = 'create_profile_screen';

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  FirebaseConnection connection = FirebaseConnection();

  String _hashtagSkills;
  String _tempHashtagSkills;
  String _hashtagWishes;
  String _tempHashtagWishes;
  File _profilePic;
  String _profilePicUrl;
  FirebaseUser loggedInUser;
  int _skillRate;
  int _wishRate;
  int _initialSkillRate;
  int _initialWishRate;
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
    var selectedImage = await ImagePicker.pickImage(source: source);
    setState(() {
      _profilePic = selectedImage;
    });
  }

  Future<String> _getAndSetLoggedInUser() async {
    loggedInUser = await connection.getCurrentUser();
    return loggedInUser.email;
  }

  void _getAndSetUserData() async {
    var userMap = await connection.getUserInfos(userID: loggedInUser.email);
    //also fill the temps in case the user presses save and the messageboxes are filled
    setState(() {
      _hashtagSkills = userMap != null ? userMap['supplyHashtags'] : null;
      _tempHashtagSkills = _hashtagSkills;
      _hashtagWishes = userMap != null ? userMap['demandHashtags'] : null;
      _tempHashtagWishes = _hashtagWishes;
      _initialSkillRate = userMap != null ? userMap['skillRate'] : null;
      _initialWishRate = userMap != null ? userMap['wishRate'] : null;
      _skillRate = _initialSkillRate;
      _wishRate = _initialWishRate;
    });
  }

  void _getAndSetData() async {
    String email = await _getAndSetLoggedInUser();
    String imgUrl = await connection.getImageUrl(fileName: email);
    var userMap = await connection.getUserInfos(userID: email);
    //also fill the temps in case the user presses save and the messageboxes are filled
    setState(() {
      _hashtagSkills = userMap != null ? userMap['supplyHashtags'] : null;
      _tempHashtagSkills = _hashtagSkills;
      _hashtagWishes = userMap != null ? userMap['demandHashtags'] : null;
      _tempHashtagWishes = _hashtagWishes;
      _initialSkillRate = userMap != null ? userMap['skillRate'] : null;
      _initialWishRate = userMap != null ? userMap['wishRate'] : null;
      _skillRate = _initialSkillRate;
      _wishRate = _initialWishRate;
      _profilePicUrl = imgUrl;
      _profilePic = null;
      showSpinner = false;
    });
  }

  @override
  void initState() {
    super.initState();
    //this is an asynchronous method
    _getAndSetData();
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
                Navigator.pushNamed(context, LoginScreen.id);
              }),
        ],
        title: Text('Create Profile'),
        backgroundColor: kDarkGreenColor,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Flexible(
                child: GestureDetector(
                  onTap: changeProfilePic,
                  child: Center(
                    child: _profilePic == null
                        ? _profilePicUrl == null
                            ? CircleAvatar(
                                backgroundImage: AssetImage(
                                    'images/default-profile-pic.jpg'),
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
              _hashtagSkills == null
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
                          _hashtagSkills = null;
                          _tempHashtagSkills = null;
                        });
                      },
                    ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Add your hourly rate',
                style: kTitleSmallTextStyle,
              ),
              RatePicker(
                initialValue: _initialSkillRate ?? 20,
                onSelected: (selectedIndex) {
                  _skillRate = selectedIndex;
                },
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
              _hashtagWishes == null
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
                          _hashtagWishes = null;
                          _tempHashtagWishes = null;
                        });
                      },
                    ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Add maximum you would be willing to pay',
                style: kTitleSmallTextStyle,
              ),
              RatePicker(
                initialValue: _initialWishRate ?? 20,
                onSelected: (selectedIndex) {
                  _wishRate = selectedIndex;
                },
              ),
              SizedBox(
                height: 5,
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
                      await connection.uploadImage(
                          fileName: loggedInUser.email, image: _profilePic);
                    }
                    print('got here');
                    await connection.uploadUserInfos(
                        userID: loggedInUser.email,
                        email: loggedInUser.email,
                        hashtagSkills: _tempHashtagSkills,
                        hashtagWishes: _tempHashtagWishes,
                        skillRate: _skillRate,
                        wishRate: _wishRate);
                    print('was able to upload');
                    await _getAndSetUserData();
                    print('was able to getAndSetUserData');
                  } catch (e) {
                    print('Could not upload and get on Save');
                  }
                  setState(() {
                    showSpinner = false;
                  });
                },
              ),
            ],
          ),
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
    //todo: the initialItem for the second CupertinoPicker does not work, maybe add a key
//    print('initialValue = $initialValue');
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
