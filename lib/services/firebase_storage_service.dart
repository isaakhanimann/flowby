import 'dart:async';
import 'dart:io';

import 'package:Flowby/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final StorageReference _storageReference = FirebaseStorage().ref();

class FirebaseStorageService {
  Future<String> uploadImage(
      {@required String fileName, @required File image}) async {
    try {
      final StorageUploadTask uploadTask =
          _storageReference.child('images/$fileName').putFile(image);
      StorageTaskSnapshot snap = await uploadTask.onComplete;
      String imageUrl = await snap.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Isaak could not upload image');
      print(e);
      return kDefaultProfilePicUrl;
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
