import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:float/constants.dart';
import 'package:float/components/rounded_button.dart';
import 'package:flutter/material.dart';

class Uploader extends StatefulWidget {
  final File file;

  Uploader({@required this.file});

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://float-a5628.appspot.com');

  StorageUploadTask _uploadTask;

  void _uploadFile() async {
    String filePath = 'images/${DateTime.now()}.png';
    _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    await _uploadTask.onComplete;
    print('File Uploaded');

    _storage.ref().child(filePath).getDownloadURL().then((fileURL) {
      print(fileURL);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      //can display something if the upload has not started
    }
    return RoundedButton(
      text: 'Save',
      color: kDarkGreenColor,
      onPressed: _uploadFile,
    );
  }
}

//return RoundedButton(
//text: 'Save',
//color: kDarkGreenColor,
//onPressed: () {
////Implement send functionality.
//userController.clear();
//_fireStore.collection('users').add(
//{
//'email': loggedInUser.email,
//'profilePic': _profilePic,
//'supplyHashtags': _hashtagSkills,
//'demandHashtags': _hashtagWishes,
//},
//);
//},
//);
