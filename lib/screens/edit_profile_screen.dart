import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/services/firebase_cloud_firestore_service.dart';
import 'package:float/services/firebase_storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final FirebaseUser loggedInUser;

  EditProfileScreen({@required this.loggedInUser});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  User user;
  String _localUsername;
  String _localHashtagSkills;
  String _localHashtagWishes;
  File _profilePic;
  int _localSkillRate;
  int _localWishRate;
  bool showSpinner = true;

  void changeProfilePic() async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('Take Photo'),
              onPressed: () {
                Navigator.pop(context);
                _setImage(ImageSource.camera);
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Choose Photo'),
              onPressed: () {
                Navigator.pop(context);
                _setImage(ImageSource.gallery);
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancel'),
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

  void _getUser(BuildContext context) async {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    String uid = widget.loggedInUser.uid;
    user = await cloudFirestoreService.getUser(uid: uid);
    //also fill the temps in case the user presses save and the messageboxes are filled
    setState(() {
      _localUsername = user.username;
      _localHashtagSkills = user.skillHashtags;
      _localHashtagWishes = user.wishHashtags;
      _localSkillRate = user?.skillRate;
      _localWishRate = user?.wishRate;
      _profilePic = null;
      showSpinner = false;
    });
  }

  @override
  void initState() {
    super.initState();
    //this is an asynchronous method
    _getUser(context);
  }

  @override
  Widget build(BuildContext context) {
    if (showSpinner) {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    final storageService =
        Provider.of<FirebaseStorageService>(context, listen: false);

    if (showSpinner) {
      return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.white,
        child: CupertinoActivityIndicator(),
      );
    }
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        leading: CupertinoButton(
          padding: EdgeInsets.all(10),
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        middle: Text('Edit Profile'),
        trailing: CupertinoButton(
            padding: EdgeInsets.all(10),
            child: Text('Done'),
            onPressed: () async {
              setState(() {
                showSpinner = true;
              });
              try {
                if (_profilePic != null) {
                  await storageService.uploadImage(
                      fileName: widget.loggedInUser.uid, image: _profilePic);
                }
                User user = User(
                    username: _localUsername,
                    uid: widget.loggedInUser.uid,
                    skillHashtags: _localHashtagSkills,
                    wishHashtags: _localHashtagWishes,
                    skillRate: _localSkillRate,
                    wishRate: _localWishRate,
                    imageFileName: widget.loggedInUser.uid);
                await cloudFirestoreService.uploadUser(user: user);
                Navigator.of(context).pop();
              } catch (e) {
                print('Could not upload and get on Save');
              }
              setState(() {
                showSpinner = false;
              });
            }),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: changeProfilePic,
                child: Center(
                  heightFactor: 1.2,
                  child: _profilePic == null
                      ? CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F${user.imageFileName}?alt=media'),
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
                  child: Text(''),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Text('Name'),
                  Expanded(
                    child: CupertinoTextField(
                      textAlign: TextAlign.center,
                      style: kMiddleTitleTextStyle,
                      onChanged: (newValue) {
                        setState(() {
                          _localUsername = newValue;
                        });
                      },
                    ),
                  )
                ],
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
              SizedBox(
                height: 15,
              ),
              Text(
                'Add your hourly rate',
                style: kSmallTitleTextStyle,
              ),
              RatePicker(
                initialValue: user.skillRate ?? 20,
                onSelected: (selectedIndex) {
                  _localSkillRate = selectedIndex;
                },
              ),
              Text(
                'Add wishes',
                style: kMiddleTitleTextStyle,
              ),
              Text(
                'Add hashtags to let people know what they can help you with',
              ),
              Text(
                'Add maximum you would be willing to pay',
                style: kSmallTitleTextStyle,
              ),
              RatePicker(
                initialValue: user.wishRate ?? 20,
                onSelected: (selectedIndex) {
                  _localWishRate = selectedIndex;
                },
              ),
              SizedBox(
                height: 5,
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
