import 'dart:io';

import 'package:Flowby/constants.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/screens/registration/user_description_registration_screen.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/services/firebase_storage_service.dart';
import 'package:Flowby/widgets/progress_bar.dart';
import 'package:Flowby/widgets/rounded_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

//TODO: change box border when the user doesn't enter an input

class UploadPictureRegistrationScreen extends StatefulWidget {
  static const String id = 'upload_picture_registration_screen';

  final User user;

  UploadPictureRegistrationScreen({this.user});

  @override
  _UploadPictureRegistrationScreenState createState() =>
      _UploadPictureRegistrationScreenState();
}

class _UploadPictureRegistrationScreenState
    extends State<UploadPictureRegistrationScreen> {
  bool showSpinner = false;
  File _profilePic;

  String _username;
  User _user;

  void _changeProfilePic() async {
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
        await ImagePicker.pickImage(source: source, imageQuality: 15);
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

  @override
  Widget build(BuildContext context) {
    widget.user.username != null
        ? _username = widget.user.username
        : _username = 'error';
    widget.user != null
        ? _user = widget.user
        : print('Why da fuck is User == NULL?!');

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.colorBurn),
          image: AssetImage("assets/images/Freeflowter_Stony.png"),
          alignment: Alignment(0.0, 0.0),
          fit: BoxFit.cover,
        ),
      ),
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kDefaultProfilePicColor),
        ),
        child: SafeArea(
          child: Scaffold(
            /*appBar: AppBar(
              title: Text('Upload a picture'),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),*/
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Stack(children: [
                Hero(
                  child: ProgressBar(progress: 0.2),
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
                          height: 10.0,
                        ),
                        Text(
                          'Welcome $_username!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratRegular',
                            fontSize: 22.0,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Choose a picture',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratRegular',
                            fontSize: 22.0,
                          ),
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
                                              "https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F$kDefaultProfilePicName?alt=media",
                                          imageBuilder:
                                              (context, imageProvider) {
                                            return CircleAvatar(
                                                radius: 60,
                                                backgroundColor: Colors.grey,
                                                backgroundImage: imageProvider);
                                          },
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
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
                                          backgroundImage:
                                              FileImage(_profilePic),
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
                        Center(
                          child: GestureDetector(
                            onTap: _changeProfilePic,
                            child: Text('Edit',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'MontserratRegular',
                                )),
                          ),
                        ),
                        RoundedButton(
                          text: 'Next',
                          color: kBlueButtonColor,
                          textColor: Colors.white,
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              if (_profilePic != null) {
                                final cloudFirestoreService =
                                Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
                                final storageService =
                                    Provider.of<FirebaseStorageService>(context,
                                        listen: false);
                                await storageService.uploadImage(
                                    fileName: _user.uid, image: _profilePic);

                                _user.imageFileName = _user.uid;
                                cloudFirestoreService.uploadProfilePic(uid: _user.uid);
                              }
                            } catch (e) {
                              print('Could not upload and get on Save');
                            }
                            Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute<void>(
                                builder: (context) {
                                  return UserDescriptionRegistrationScreen(
                                    user: _user,
                                  );
                                },
                              ),
                            );
                            setState(() {
                              showSpinner = false;
                            });
                          },
                        ),

                      ]),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
