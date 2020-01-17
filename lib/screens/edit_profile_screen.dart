import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/choose_signup_or_login_screen.dart';
import 'package:float/services/firebase_auth_service.dart';
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
  bool _localHasSkills;
  bool _localHasWishes;
  File _profilePic;
  int _localSkillRate;
  int _localWishRate;
  bool showSpinner = true;

  var _usernameController = TextEditingController();
  var _bioController = TextEditingController();
  var _hashtagSkillController = TextEditingController();
  var _hashtagWishController = TextEditingController();

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
      _usernameController.text = user.username;
      _bioController.text = user.bio;
      _localHasSkills = user.hasSkills;
      _localHasWishes = user.hasWishes;
      _hashtagSkillController.text = user.skillHashtags;
      _hashtagWishController.text = user.wishHashtags;
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

  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _hashtagSkillController.dispose();
    _hashtagWishController.dispose();
    super.dispose();
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
        border: null,
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
                    username: _usernameController.text,
                    uid: widget.loggedInUser.uid,
                    bio: _bioController.text,
                    hasSkills: _localHasSkills,
                    hasWishes: _localHasWishes,
                    skillHashtags: _hashtagSkillController.text,
                    wishHashtags: _hashtagWishController.text,
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
                      ? Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Opacity(
                              opacity: 0.4,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F${user.imageFileName}?alt=media'),
                              ),
                            ),
                            Icon(
                              CupertinoIcons.photo_camera_solid,
                              size: 50,
                            )
                          ],
                        )
                      : Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Opacity(
                              opacity: 0.4,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: FileImage(_profilePic),
                                radius: 60,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.photo_camera_solid,
                              size: 50,
                            )
                          ],
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Name',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  Expanded(
                    child: CupertinoTextField(
                      style: TextStyle(color: kGrey3, fontSize: 22),
                      padding: EdgeInsets.only(bottom: 0),
                      maxLength: 20,
                      maxLines: 1,
                      decoration: BoxDecoration(border: null),
                      controller: _usernameController,
                      textAlign: TextAlign.start,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Bio',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  Expanded(
                    child: CupertinoTextField(
                      style: TextStyle(color: kGrey3, fontSize: 20),
                      placeholder: _bioController.text == ''
                          ? 'Enter your description'
                          : '',
                      maxLength: 200,
                      maxLines: 5,
                      padding: EdgeInsets.only(bottom: 0),
                      decoration: BoxDecoration(border: null),
                      controller: _bioController,
                      textAlign: TextAlign.start,
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Skills',
                    style: kMiddleTitleTextStyle,
                  ),
                  CupertinoSwitch(
                    value: _localHasSkills,
                    onChanged: (newBool) {
                      setState(() {
                        _localHasSkills = newBool;
                      });
                    },
                  ),
                ],
              ),
              if (_localHasSkills)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    CupertinoTextField(
                      style: TextStyle(color: kGrey3, fontSize: 20),
                      placeholder: _hashtagSkillController.text == ''
                          ? 'Enter your skills'
                          : '',
                      maxLength: 20,
                      maxLines: 1,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: kLightGrey),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      controller: _hashtagSkillController,
                      textAlign: TextAlign.center,
                    ),
                    RatePicker(
                      initialValue: user.skillRate ?? 20,
                      onSelected: (selectedIndex) {
                        _localSkillRate = selectedIndex;
                      },
                    ),
                  ],
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Wishes',
                    style: kMiddleTitleTextStyle,
                  ),
                  CupertinoSwitch(
                    value: _localHasWishes,
                    onChanged: (newBool) {
                      setState(() {
                        _localHasWishes = newBool;
                      });
                    },
                  ),
                ],
              ),
              if (_localHasWishes)
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    CupertinoTextField(
                      style: TextStyle(color: kGrey3, fontSize: 20),
                      placeholder: _hashtagWishController.text == ''
                          ? 'Enter your wishes'
                          : '',
                      maxLength: 20,
                      maxLines: 1,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: kLightGrey),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      controller: _hashtagWishController,
                      textAlign: TextAlign.center,
                    ),
                    RatePicker(
                      initialValue: user.wishRate ?? 20,
                      onSelected: (selectedIndex) {
                        _localWishRate = selectedIndex;
                      },
                    ),
                  ],
                ),
              SizedBox(
                height: 20,
              ),
              CupertinoButton(
                child: Text(
                  'Delete Account',
                  style: TextStyle(color: CupertinoColors.destructiveRed),
                ),
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (_) => CupertinoAlertDialog(
                      title: Text('Are you sure?'),
                      content:
                          Text('Do you really want to delete all your info?'),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text('Delete'),
                          onPressed: () async {
                            final authService =
                                Provider.of<FirebaseAuthService>(context);
                            print('delete user called');
                            await authService.deleteCurrentlyLoggedInUser();
                            Navigator.of(context).push(
                              CupertinoPageRoute<void>(
                                builder: (context) {
                                  return ChooseSignupOrLoginScreen();
                                },
                              ),
                            );
                          },
                          isDestructiveAction: true,
                        ),
                      ],
                    ),
                  );
                },
              )
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
      textList.add(Text(
        i.toString(),
        style: TextStyle(fontSize: 16),
      ));
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
            itemExtent: 21,
            onSelectedItemChanged: onSelected,
            children: _getPickerItems(),
          ),
        ),
        Text(
          'CHF/h',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
