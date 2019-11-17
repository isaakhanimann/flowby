import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = Firestore.instance;
final _auth = FirebaseAuth.instance;
final StorageReference _storageReference = FirebaseStorage().ref();

class FirebaseConnection {
  Future<FirebaseUser> getCurrentUser() async {
    final user = await _auth.currentUser();
    return user;
  }

  void signOut() {
    _auth.signOut();
  }

  Future<void> uploadImage(
      {@required String fileName, @required File image}) async {
    try {
      final StorageUploadTask uploadTask =
          _storageReference.child('images/$fileName').putFile(image);
      await uploadTask.onComplete;
    } catch (e) {
      print('Isaak could not upload image');
    }
  }

  Future<String> getImageUrl({@required String fileName}) async {
    try {
      final String downloadUrl =
          await _storageReference.child('images/$fileName').getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Isaak could get image url');
      return null;
    }
  }

  Future<void> uploadUserInfos(
      {@required String userID,
      @required String email,
      @required String hashtagSkills,
      @required String hashtagWishes,
      @required int skillRate,
      @required int wishRate}) async {
    try {
      _fireStore.collection('users').document(userID).setData({
        'email': email,
        'supplyHashtags': hashtagSkills,
        'demandHashtags': hashtagWishes,
        'skillRate': skillRate,
        'wishRate': wishRate
      });
    } catch (e) {
      print('Isaak could not upload user info');
    }
  }

  Future<Map<String, dynamic>> getUserInfos({@required String userID}) async {
    try {
      var userDocument =
          await _fireStore.collection('users').document(userID).get();
      return userDocument?.data;
    } catch (e) {
      print('Isaak could not get user info');
      return null;
    }
  }
}
