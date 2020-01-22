import 'dart:io';

import 'package:float/constants.dart';
import 'package:float/screens/registration/user_description_registration_screen.dart';
import 'package:float/services/firebase_storage_service.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:float/widgets/progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'package:float/models/user.dart';

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
  String _profilePicUrl;

  String _username;
  User _user;

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

  @override
  Widget build(BuildContext context) {
    widget.user.username != null
        ? _username = widget.user.username
        : _username = 'error';
    widget.user != null
        ? _user = widget.user
        : print('Why da fuck is User == NULL?!');

    _user.imageFileName = "default-profile-pic.jpg";

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
          valueColor: AlwaysStoppedAnimation<Color>(kDarkGreenColor),
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
                ProgressBar(progress: 0.25),
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
                          'Choose a picture',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratRegular',
                            fontSize: 22.0,
                          ),
                        ),
                        GestureDetector(
                          onTap: changeProfilePic,
                          child: Center(
                            heightFactor: 1.2,
                            child: _profilePic == null
                                ? _profilePicUrl == null
                                    ? CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        backgroundImage: AssetImage(
                                            'assets/images/default-profile-pic.jpg'),
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
                            child: Text('Edit',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'MontserratRegular',
                                )),
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
                                final storageService =
                                    Provider.of<FirebaseStorageService>(context,
                                        listen: false);
                                await storageService.uploadImage(
                                    fileName: _user.uid, image: _profilePic);

                                _user.imageFileName = _user.uid;
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
                        Text(
                          'Hello $_username, welcome!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratRegular',
                            fontSize: 22.0,
                          ),
                        ),
                        Container(
                          height: 350.0,
                          width: 350.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  Colors.white, BlendMode.colorBurn),
                              image: AssetImage(
                                  "assets/images/Freeflowter_Stony.png"),
                              alignment: Alignment(0.0, 0.0),
                              fit: BoxFit.cover,
                            ),
                          ),
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
