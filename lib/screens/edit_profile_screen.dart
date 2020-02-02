import 'dart:io';

import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/choose_signup_or_login_screen.dart';
import 'package:Flowby/services/firebase_auth_service.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/services/firebase_storage_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({@required this.user});

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

  List<TextEditingController> skillKeywordControllers = [];
  List<TextEditingController> skillDescriptionControllers = [];
  List<TextEditingController> skillPriceControllers = [];
  List<TextEditingController> wishKeywordControllers = [];
  List<TextEditingController> wishDescriptionControllers = [];
  List<TextEditingController> wishPriceControllers = [];

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
      _localHasSkills = user.hasSkills;
      _localHasWishes = user.hasWishes;
      user.skillz?.forEach((SkillOrWish skillOrWish) {
        skillKeywordControllers
            .add(TextEditingController(text: skillOrWish.keywords));
        skillDescriptionControllers
            .add(TextEditingController(text: skillOrWish.description));
        skillPriceControllers
            .add(TextEditingController(text: skillOrWish.price));
      });
      //controllers for extra skill
      skillKeywordControllers.add(TextEditingController());
      skillDescriptionControllers.add(TextEditingController());
      skillPriceControllers.add(TextEditingController());

      user.wishez?.forEach((SkillOrWish skillOrWish) {
        wishKeywordControllers
            .add(TextEditingController(text: skillOrWish.keywords));
        wishDescriptionControllers
            .add(TextEditingController(text: skillOrWish.description));
        wishPriceControllers
            .add(TextEditingController(text: skillOrWish.price));
      });
      wishKeywordControllers.add(TextEditingController());
      wishDescriptionControllers.add(TextEditingController());
      wishPriceControllers.add(TextEditingController());

      _localSkillRate = user?.skillRate;
      _localWishRate = user?.wishRate;
      _profilePic = null;
      showSpinner = false;
    });
  }

  Widget _addRowButton(isSkillBuild) {
    return Container(
      alignment: Alignment.bottomLeft,
      child: GestureDetector(
        child: Icon(Feather.plus),
        onTap: () {
          setState(() {
            if (isSkillBuild) {
              skillKeywordControllers.add(TextEditingController());
              skillDescriptionControllers.add(TextEditingController());
              skillPriceControllers.add(TextEditingController());
            } else {
              wishKeywordControllers.add(TextEditingController());
              wishDescriptionControllers.add(TextEditingController());
              wishPriceControllers.add(TextEditingController());
            }
          });
        },
      ),
    );
  }

  Column _buildListOfRows({bool isSkillBuild}) {
    List<Widget> rows = [];
    for (int rowNumber = 0;
        rowNumber <
            (isSkillBuild
                ? skillKeywordControllers.length
                : wishKeywordControllers.length);
        rowNumber++) {
      rows.add(
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CupertinoTextField(
                      expands: true,
                      minLines: null,
                      maxLines: null,
                      style: kAddSkillsTextStyle,
                      maxLength: 20,
                      decoration: null,
                      textAlign: TextAlign.start,
                      placeholder: "#keywords",
                      controller: isSkillBuild
                          ? skillKeywordControllers[rowNumber]
                          : wishKeywordControllers[rowNumber],
                    ),
                    SizedBox(width: 20),
                    CupertinoTextField(
                      expands: true,
                      maxLines: null,
                      minLines: null,
                      style: kAddSkillsTextStyle,
                      maxLength: 10,
                      decoration: null,
                      textAlign: TextAlign.start,
                      placeholder: "price",
                      controller: isSkillBuild
                          ? skillPriceControllers[rowNumber]
                          : wishPriceControllers[rowNumber],
                    ),
                  ],
                ),
                CupertinoTextField(
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  style: kAddSkillsTextStyle,
                  maxLength: 100,
                  decoration: null,
                  textAlign: TextAlign.start,
                  placeholder: "description",
                  controller: isSkillBuild
                      ? skillDescriptionControllers[rowNumber]
                      : wishDescriptionControllers[rowNumber],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: GestureDetector(
                onTap: () => setState(() {
                  if (isSkillBuild) {
                    skillKeywordControllers.removeAt(rowNumber);
                    skillDescriptionControllers.removeAt(rowNumber);
                    skillPriceControllers.removeAt(rowNumber);
                  } else {
                    wishKeywordControllers.removeAt(rowNumber);
                    wishDescriptionControllers.removeAt(rowNumber);
                    wishPriceControllers.removeAt(rowNumber);
                  }
                }),
                child: Icon(Feather.x),
              ),
            ),
          ],
        ),
      );
    }

    rows.add(_addRowButton(isSkillBuild));
    return Column(
      children: rows,
    );
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
    List<TextEditingController> allControllers = skillKeywordControllers +
        skillDescriptionControllers +
        wishKeywordControllers +
        wishDescriptionControllers;
    for (TextEditingController controller in allControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (true) {
      return CupertinoPageScaffold(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 50,
                            width: 50,
                            color: Colors.blue,
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            color: Colors.green,
                          )
                        ],
                      ),
                      Container(
                        height: 50,
                        width: 100,
                        color: Colors.yellow,
                      )
                    ],
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    color: Colors.red,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 50,
                            width: 50,
                            color: Colors.blue,
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            color: Colors.green,
                          )
                        ],
                      ),
                      Container(
                        height: 50,
                        width: 100,
                        color: Colors.yellow,
                      )
                    ],
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    color: Colors.red,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 50,
                            width: 50,
                            color: Colors.blue,
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            color: Colors.green,
                          )
                        ],
                      ),
                      Container(
                        height: 50,
                        width: 100,
                        color: Colors.yellow,
                      )
                    ],
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    color: Colors.red,
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (showSpinner) {
      return CupertinoPageScaffold(
        backgroundColor: Colors.white,
        child: Center(
          child: SizedBox(
            width: 200,
            child: FlareActor(
              'assets/animations/liquid_loader.flr',
              alignment: Alignment.center,
              color: kDefaultProfilePicColor,
              fit: BoxFit.contain,
              animation: "Untitled",
            ),
          ),
        ),
      );
    }
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    final storageService =
        Provider.of<FirebaseStorageService>(context, listen: false);

    if (showSpinner) {
      return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.white,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
          ),
        ),
      );
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
            onPressed: () async {
              setState(() {
                showSpinner = true;
              });
              try {
                if (_profilePic != null) {
                  await storageService.uploadImage(
                      fileName: widget.user.uid, image: _profilePic);
                }

                // only add a skill to the user if the keywords are not null or empty
                List<SkillOrWish> skillz =
                    User.controllersToListOfSkillsOrWishes(
                        keywordsControllers: skillKeywordControllers,
                        descriptionControllers: skillDescriptionControllers,
                        priceControllers: skillPriceControllers);
                List<SkillOrWish> wishez =
                    User.controllersToListOfSkillsOrWishes(
                        keywordsControllers: wishKeywordControllers,
                        descriptionControllers: wishDescriptionControllers,
                        priceControllers: wishPriceControllers);

                User user = User(
                    username: _usernameController.text,
                    uid: widget.user.uid,
                    bio: _bioController.text,
                    hasSkills: _localHasSkills,
                    hasWishes: _localHasWishes,
                    skillRate: _localSkillRate,
                    wishRate: _localWishRate,
                    skillz: skillz,
                    wishez: wishez,
                    imageFileName: widget.user.uid);
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
                                    "https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F${user.imageFileName}?alt=media",
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
                      style: kEditProfileTextFieldTextStyle,
                    ),
                  ),
                  Expanded(
                    child: CupertinoTextField(
                      style: kEditProfileTextFieldTextStyle,
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
                      style: kEditProfileTextFieldTextStyle,
                    ),
                  ),
                  Expanded(
                    child: CupertinoTextField(
                      expands: true,
                      style: kEditProfileTextFieldTextStyle,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Skills',
                    style: kSkillsTitleTextStyle,
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
                    _buildListOfRows(isSkillBuild: true),
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
                    style: kSkillsTitleTextStyle,
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
                    _buildListOfRows(isSkillBuild: false),
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
        style: kAddSkillsTextStyle,
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
            itemExtent: 27,
            onSelectedItemChanged: onSelected,
            children: _getPickerItems(),
          ),
        ),
        Text(
          'CHF/h',
          style: kAddSkillsTextStyle,
        ),
      ],
    );
  }
}
