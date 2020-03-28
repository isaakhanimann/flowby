import 'dart:io';
import 'dart:async';

import 'package:Flowby/app_localizations.dart';
import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/registration/add_skills_or_wishes_registration_screen.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/widgets/progress_bar.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Flowby/services/firebase_storage_service.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:Flowby/widgets/centered_loading_indicator.dart';
import 'package:Flowby/models/helper_functions.dart';
import 'package:Flowby/widgets/basic_dialog.dart';

class AddImageUsernameAndBioRegistrationScreen extends StatefulWidget {
  static const String id = 'add_username_registration_screen';

  final User user;

  AddImageUsernameAndBioRegistrationScreen({this.user});

  @override
  _AddImageUsernameAndBioRegistrationScreenState createState() =>
      _AddImageUsernameAndBioRegistrationScreenState();
}

class _AddImageUsernameAndBioRegistrationScreenState
    extends State<AddImageUsernameAndBioRegistrationScreen> {
  bool showSpinner = false;

  File _profilePic;
  String _username;
  String _bio;

  @override
  void initState() {
    super.initState();
    if (widget.user.username != null && widget.user.username != '') {
      _username = widget.user.username;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: SizedBox(
          width: 200,
          child: FlareActor(
            'assets/animations/liquid_loader.flr',
            alignment: Alignment.center,
            color: kDefaultProfilePicColor,
            fit: BoxFit.contain,
            animation: "Untitled",
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Stack(children: [
              Hero(
                child: ProgressBar(progress: 0.5),
                transitionOnUserGestures: true,
                tag: 'progress_bar',
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate('whats_your_name'),
                        textAlign: TextAlign.center,
                        style: kRegisterHeaderTextStyle,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      CupertinoTextField(
                        style: kEditProfileTextFieldTextStyle,
                        placeholder: AppLocalizations.of(context)
                            .translate('enter_your_name'),
                        textCapitalization: TextCapitalization.words,
                        maxLength: 35,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: kBoxBorderColor),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        onChanged: (value) {
                          _username = value;
                        },
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate('let_others_know_who_you_are'),
                        textAlign: TextAlign.center,
                        style: kRegisterHeaderTextStyle,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      CupertinoTextField(
                        style: kEditProfileTextFieldTextStyle,
                        placeholder:
                            AppLocalizations.of(context).translate('your_bio'),
                        maxLength: 200,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 4,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: kBoxBorderColor),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        onChanged: (value) {
                          _bio = value;
                        },
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate('choose_picture'),
                        textAlign: TextAlign.center,
                        style: kRegisterHeaderTextStyle,
                      ),
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
                                            "https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F$kDefaultProfilePicUrl?alt=media",
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
                      RoundedButton(
                        text: AppLocalizations.of(context).translate('next'),
                        color: kBlueButtonColor,
                        textColor: Colors.white,
                        onPressed: () {
                          _uploadImageAndUserAndNavigate(context);
                        },
                      ),
                    ]),
              ),
            ]),
          ),
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
              child: Text(
                AppLocalizations.of(context).translate('take_photo'),
              ),
              onPressed: () {
                Navigator.pop(context);
                _setImage(ImageSource.camera);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                AppLocalizations.of(context).translate('choose_photo'),
              ),
              onPressed: () {
                Navigator.pop(context);
                _setImage(ImageSource.gallery);
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(
              AppLocalizations.of(context).translate('cancel'),
            ),
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
    // This do-while loop allows the user to return back to the camera or the gallery if he presses the back button in the image_cropperjj
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
      setState(() {
        _profilePic = croppedImage;
      });
    }
  }

  Future<void> _uploadImageAndUserAndNavigate(BuildContext context) async {
    if (_username == null) {
      HelperFunctions.showCustomDialog(
        context: context,
        dialog: BasicDialog(
          title: AppLocalizations.of(context).translate('name_is_missing'),
          text: AppLocalizations.of(context).translate('please_enter_name'),
        ),
      );
      return;
    }
    setState(() {
      showSpinner = true;
    });
    try {
      if (_profilePic != null) {
        final storageService =
            Provider.of<FirebaseStorageService>(context, listen: false);
        await storageService.uploadImage(
            fileName: widget.user.uid, image: _profilePic);
      }
    } catch (e) {
      print('Could not upload image');
    }

    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    final storageService =
        Provider.of<FirebaseStorageService>(context, listen: false);
    if (_profilePic != null) {
      String imageUrl = await storageService.uploadImage(
          fileName: widget.user.uid, image: _profilePic);
      widget.user.imageUrl = imageUrl;
    }
    widget.user.username = _username;
    widget.user.bio = _bio;
    print(widget.user);
    await cloudFirestoreService.uploadUser(user: widget.user);
    setState(() {
      showSpinner = false;
    });
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute<void>(
        builder: (context) {
          return AddSkillsOrWishesRegistrationScreen(
            user: widget.user,
          );
        },
      ),
    );
  }
}
