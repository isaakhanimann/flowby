import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final StorageReference _storageReference = FirebaseStorage().ref();

class FirebaseStorageService {
  Future<void> uploadImage(
      {@required String fileName, @required File image}) async {
    try {
      //the imagefilename and imageversionnumber of the user document is updated with cloud functions
      final StorageUploadTask uploadTask =
          _storageReference.child('images/$fileName').putFile(image);
      await uploadTask.onComplete;
    } catch (e) {
      print('Isaak could not upload image');
      print(e);
    }
  }

  Future<String> getImageUrl({@required String fileName}) async {
    try {
      final String downloadUrl =
          await _storageReference.child('images/$fileName').getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Isaak could not get image url');
      return null;
    }
  }
}
