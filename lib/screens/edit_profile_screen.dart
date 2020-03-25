import 'dart:io';
import 'dart:async';

import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/services/firebase_storage_service.dart';
import 'package:Flowby/widgets/centered_loading_indicator.dart';
import 'package:Flowby/widgets/create_skills_section.dart';
import 'package:Flowby/widgets/create_wishes_section.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/models/role.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({@required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File _profilePic;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    widget.user.addEmptySkill();
    widget.user.addEmptyWish();

    _profilePic = null;
    showSpinner = false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<User>.value(value: widget.user),
        Provider<File>.value(value: _profilePic)
      ],
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CenteredLoadingIndicator(),
        child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            border: null,
            backgroundColor: Colors.transparent,
            leading: CupertinoButton(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(AppLocalizations.of(context).translate('cancel'),
                  style: kActionNavigationBarTextStyle),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            middle: Text(
              AppLocalizations.of(context).translate('edit_profile'),
              textAlign: TextAlign.center,
            ),
            trailing: CupertinoButton(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Text(AppLocalizations.of(context).translate('done'),
                    style: kActionNavigationBarTextStyle),
                onPressed: () {
                  _uploadUserAndNavigate(context);
                }),
          ),
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 15),
              children: <Widget>[
                ImageSection(
                  setProfilePic: _setProfilePic,
                ),
                SizedBox(
                  height: 20,
                ),
                NameBioHideSection(),
                SizedBox(height: 20),
                ChooseRoleAndSkillSection(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

      widget.user.skills?.removeWhere(
          (skill) => (skill.keywords == null || skill.keywords.isEmpty));
      widget.user.wishes?.removeWhere(
          (wish) => (wish.keywords == null || wish.keywords.isEmpty));

      await cloudFirestoreService.uploadUser(user: widget.user);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
      print('Could not upload and get on Save');
    }
    setState(() {
      showSpinner = false;
    });
  }

  _setProfilePic(File newImage) {
    _profilePic = newImage;
  }
}

class ImageSection extends StatefulWidget {
  final Function setProfilePic;

  ImageSection({@required this.setProfilePic});

  @override
  _ImageSectionState createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  File _profilePic;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    return GestureDetector(
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
                      placeholder: (context, url) => SizedBox(
                        height: 120,
                        child: CenteredLoadingIndicator(),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
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
    );
  }

  void _changeProfilePic() async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(AppLocalizations.of(context).translate('take_photo')),
              onPressed: () {
                Navigator.pop(context);
                _setImage(ImageSource.camera);
              },
            ),
            CupertinoActionSheetAction(
              child:
                  Text(AppLocalizations.of(context).translate('choose_photo')),
              onPressed: () {
                Navigator.pop(context);
                _setImage(ImageSource.gallery);
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(AppLocalizations.of(context).translate('cancel')),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
    );
  }

  void _setImage(ImageSource source) async {
    var selectedImage = await ImagePicker.pickImage(source: source);
    File croppedImage;
    do {
      if (selectedImage != null) {
        croppedImage = await ImageCropper.cropImage(
            sourcePath: selectedImage.path,
            aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
            cropStyle: CropStyle.circle,
            androidUiSettings: AndroidUiSettings(
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            iosUiSettings: IOSUiSettings(
              minimumAspectRatio: 1.0,
            ));
      }
      if (croppedImage != null) break;
      selectedImage = await ImagePicker.pickImage(source: source);
    } while ((croppedImage == null && selectedImage != null));
    if (croppedImage != null) {
      widget.setProfilePic(croppedImage);
      setState(() {
        _profilePic = croppedImage;
      });
    }
  }
}

class NameBioHideSection extends StatefulWidget {
  @override
  _NameBioHideSectionState createState() => _NameBioHideSectionState();
}

class _NameBioHideSectionState extends State<NameBioHideSection> {
  TextEditingController _usernameController;
  TextEditingController _bioController;
  bool _hideProfile;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<User>(context, listen: false);
    _usernameController = TextEditingController(text: user.username);
    _usernameController.addListener(() {
      user.username = _usernameController.text;
    });
    _bioController = TextEditingController(text: user.bio);
    _bioController.addListener(() {
      user.bio = _bioController.text;
    });
    _hideProfile = user.isHidden;
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    return Card(
      elevation: 0,
      color: kCardBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: Text(
                    AppLocalizations.of(context).translate('name'),
                    style: kAddSkillsTextStyle,
                  ),
                ),
                Expanded(
                  child: CupertinoTextField(
                    style: kAddSkillsTextStyle,
                    placeholder: AppLocalizations.of(context)
                        .translate('enter_your_name'),
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
                    AppLocalizations.of(context).translate('bio'),
                    style: kAddSkillsTextStyle,
                  ),
                ),
                Expanded(
                  child: CupertinoTextField(
                    expands: true,
                    style: kAddSkillsTextStyle,
                    placeholder: AppLocalizations.of(context)
                        .translate('enter_description'),
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
                    AppLocalizations.of(context).translate('hide_profile'),
                    style: kAddSkillsTextStyle,
                  ),
                ),
                CupertinoSwitch(
                  value: _hideProfile,
                  onChanged: (newBool) {
                    setState(() {
                      user.isHidden = newBool;
                      _hideProfile = newBool;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChooseRoleAndSkillSection extends StatefulWidget {
  @override
  _ChooseRoleAndSkillSectionState createState() =>
      _ChooseRoleAndSkillSectionState();
}

class _ChooseRoleAndSkillSectionState extends State<ChooseRoleAndSkillSection> {
  Role _role;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<User>(context, listen: false);
    _role = user.role;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        CupertinoSegmentedControl(
          padding: EdgeInsets.symmetric(horizontal: 0),
          groupValue: _role,
          onValueChanged: _switchRole,
          children: <Role, Widget>{
            Role.consumer: Text(
                AppLocalizations.of(context).translate('searcher'),
                style: kHomeSwitchTextStyle),
            Role.provider: Text(
                AppLocalizations.of(context).translate('provider'),
                style: kHomeSwitchTextStyle),
          },
        ),
        SizedBox(height: 20),
        Card(
          elevation: 0,
          color: kCardBackgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            child: _role == Role.provider
                ? Column(
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate('skills'),
                        style: kSkillsTitleTextStyle,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CreateSkillsSection(
                        initialSkills: user.skills,
                        updateKeywordsAtIndex: user.updateSkillKeywordsAtIndex,
                        updateDescriptionAtIndex:
                            user.updateSkillDescriptionAtIndex,
                        updatePriceAtIndex: user.updateSkillPriceAtIndex,
                        addEmptySkill: user.addEmptySkill,
                        deleteSkillAtIndex: user.deleteSkillAtIndex,
                      ),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate('wishes'),
                        style: kSkillsTitleTextStyle,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CreateWishesSection(
                        initialWishes: user.wishes,
                        updateKeywordsAtIndex: user.updateWishKeywordsAtIndex,
                        updateDescriptionAtIndex:
                            user.updateWishDescriptionAtIndex,
                        updatePriceAtIndex: user.updateWishPriceAtIndex,
                        addEmptyWish: user.addEmptyWish,
                        deleteWishAtIndex: user.deleteWishAtIndex,
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  _switchRole(Role newRole) {
    final user = Provider.of<User>(context, listen: false);
    user.role = newRole;
    setState(() {
      _role = newRole;
    });
  }
}
