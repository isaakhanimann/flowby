import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:float/constants.dart';
import 'package:float/components/rounded_button.dart';
import 'package:flutter/material.dart';

final _fireStore = Firestore.instance;
final StorageReference _storageReference =
    FirebaseStorage().ref().child('images/isaak.png');

class Uploader extends StatefulWidget {
  final File image;
  final String email;
  final String supplyHashtags;
  final String demandHashtags;

  Uploader(
      {@required this.image,
      @required this.email,
      @required this.supplyHashtags,
      @required this.demandHashtags});

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  void _uploadImage() async {
    final StorageUploadTask uploadTask =
        _storageReference.putFile(widget.image);
    await uploadTask.onComplete;
    print('File Uploaded');

    _storageReference.getDownloadURL().then((fileURL) {
      print(fileURL);
    });
  }

  void _uploadUserInfos() async {
    print(widget.email);
    print(widget.supplyHashtags);
    print(widget.demandHashtags);
    _fireStore.collection('users').add({
      'email': widget.email,
      'supplyHashtags': widget.supplyHashtags,
      'demandHashtags': widget.demandHashtags,
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      text: 'Save',
      color: kDarkGreenColor,
      onPressed: () {
        _uploadImage();
        _uploadUserInfos();
      },
    );
  }
}
