import 'dart:io';

import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/services/firebase_storage_service.dart';
import 'package:Flowby/widgets/centered_loading_indicator.dart';
import 'package:Flowby/widgets/list_of_textfields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/models/role.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({@required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  User user;
  bool _isHidden;
  File _profilePic;
  bool showSpinner = true;
  Role _role;

  var _usernameController = TextEditingController();
  var _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //this is an asynchronous method
    _getUser(context);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (showSpinner) {
      return CupertinoPageScaffold(
          backgroundColor: CupertinoColors.white,
          child: CenteredLoadingIndicator());
    }
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        border: null,
        backgroundColor: Colors.transparent,
        leading: CupertinoButton(
          padding: EdgeInsets.all(10),
          child: Text('Cancel', style: kNavigationBarTextStyle),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        middle: Text('Edit Profile', style: kNavigationBarTextStyle),
        trailing: CupertinoButton(
            padding: EdgeInsets.all(10),
            child: Text('Done', style: kNavigationBarTextStyle),
            onPressed: () {
              _uploadUserAndNavigate(context);
            }),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: _changeProfilePic,
                child: Center(
                  heightFactor: 1.2,
                  child: _profilePic == null
                      ? Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Opacity(
                              opacity: 0.4,
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F${user.imageFileName}?alt=media&version=${user.imageVersionNumber}",
                                imageBuilder: (context, imageProvider) {
                                  return CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Colors.grey,
                                      backgroundImage: imageProvider);
                                },
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      kDefaultProfilePicColor),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
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
                      style: kAddSkillsTextStyle,
                    ),
                  ),
                  Expanded(
                    child: CupertinoTextField(
                      style: kAddSkillsTextStyle,
                      placeholder: 'Enter your name',
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
                      style: kAddSkillsTextStyle,
                    ),
                  ),
                  Expanded(
                    child: CupertinoTextField(
                      expands: true,
                      style: kAddSkillsTextStyle,
                      placeholder: 'Enter your description',
                      maxLength: 200,
                      minLines: null,
                      maxLines: null,
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
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Hide Profile',
                      style: kAddSkillsTextStyle,
                    ),
                  ),
                  CupertinoSwitch(
                    value: _isHidden,
                    onChanged: (newBool) {
                      setState(() {
                        _isHidden = newBool;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              CupertinoSegmentedControl(
                padding: EdgeInsets.symmetric(horizontal: 0),
                groupValue: _role,
                onValueChanged: _switchRole,
                children: <Role, Widget>{
                  Role.consumer: Text('Searcher', style: kHomeSwitchTextStyle),
                  Role.provider: Text('Provider', style: kHomeSwitchTextStyle),
                },
              ),
              SizedBox(height: 20),
              if (_role == Role.provider)
                Column(
                  children: <Widget>[
                    Text(
                      'Skills',
                      style: kSkillsTitleTextStyle,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListOfTextfields(
                      key: UniqueKey(),
                      initialSkillsOrWishes: user.skills,
                      updateKeywordsAtIndex: user.updateSkillKeywordsAtIndex,
                      updateDescriptionAtIndex:
                          user.updateSkillDescriptionAtIndex,
                      updatePriceAtIndex: user.updateSkillPriceAtIndex,
                      addEmptySkillOrWish: user.addEmptySkill,
                      deleteSkillOrWishAtIndex: user.deleteSkillAtIndex,
                    ),
                  ],
                ),
              if (_role == Role.consumer)
                Column(
                  children: <Widget>[
                    Text(
                      'Wishes',
                      style: kSkillsTitleTextStyle,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListOfTextfields(
                      key: UniqueKey(),
                      initialSkillsOrWishes: user.wishes,
                      updateKeywordsAtIndex: user.updateWishKeywordsAtIndex,
                      updateDescriptionAtIndex:
                          user.updateWishDescriptionAtIndex,
                      updatePriceAtIndex: user.updateWishPriceAtIndex,
                      addEmptySkillOrWish: user.addEmptyWish,
                      deleteSkillOrWishAtIndex: user.deleteWishAtIndex,
                    ),
                  ],
                ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _switchRole(Role newRole) {
    setState(() {
      _role = newRole;
    });
  }

  Future<void> _uploadUserAndNavigate(BuildContext context) async {
    setState(() {
      showSpinner = true;
    });
    try {
      final cloudFirestoreService =
          Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

      final storageService =
          Provider.of<FirebaseStorageService>(context, listen: false);

      if (_profilePic != null) {
        await storageService.uploadImage(
            fileName: widget.user.uid, image: _profilePic);
      }

      user.username = _usernameController.text;
      user.isHidden = _isHidden;
      user.role = _role;
      user.skills.removeWhere(
          (skill) => (skill.keywords == null || skill.keywords.isEmpty));
      user.wishes.removeWhere(
          (wish) => (wish.keywords == null || wish.keywords.isEmpty));
      user.bio = _bioController.text;

      await cloudFirestoreService.uploadUser(user: user);
      Navigator.of(context).pop();
    } catch (e) {
      print('Could not upload and get on Save');
    }
    setState(() {
      showSpinner = false;
    });
  }

  void _changeProfilePic() async {
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
        await ImagePicker.pickImage(source: source, imageQuality: 20);

    File croppedImage = await ImageCropper.cropImage(
        sourcePath: selectedImage.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: AndroidUiSettings(
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      _profilePic = croppedImage;
    });
  }

  void _getUser(BuildContext context) async {
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    String uid = widget.user.uid;
    user = await cloudFirestoreService.getUser(uid: uid);
    //also fill the temps in case the user presses save and the messageboxes are filled

    setState(() {
      _usernameController.text = user.username;
      _bioController.text = user.bio;
      _isHidden = user.isHidden;
      _role = user.role;

      _profilePic = null;
      showSpinner = false;
    });
  }
}
