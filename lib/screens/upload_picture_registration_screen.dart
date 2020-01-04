import 'dart:io';

import 'package:float/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

//TODO: change box border when the user doesn't enter an input

class UploadPictureRegistrationScreen extends StatefulWidget {
  static const String id = 'upload_picture_registration_screen';

  @override
  _UploadPictureRegistrationScreenState createState() =>
      _UploadPictureRegistrationScreenState();
}

class _UploadPictureRegistrationScreenState
    extends State<UploadPictureRegistrationScreen> {
  bool showSpinner = false;
  File _profilePic;
  String _profilePicUrl;
  FirebaseUser loggedInUser;

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

  void _getLoggedInUser() async {
    loggedInUser = await FirebaseConnection.getCurrentUser();
  }

  @override
  void initState() {
    super.initState();
    FirebaseConnection.autoLogin(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.colorBurn),
          image: AssetImage("images/Freeflowter_Stony_Fond1.png"),
          alignment: Alignment(0.0, 0.0),
          fit: BoxFit.cover,
        ),
      ),
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kDarkGreenColor),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Upload a picture'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                        'images/default-profile-pic_old.jpg'),
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
                    RoundedButton(
                      text: 'Next',
                      color: ffDarkBlue,
                      textColor: Colors.white,
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          if (_profilePic != null) {
                            _getLoggedInUser();
                            await FirebaseConnection.uploadImage(
                                fileName: loggedInUser.email,
                                image: _profilePic);
                          }
                        } catch (e) {
                          print('Could not upload and get on Save');
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      },
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
