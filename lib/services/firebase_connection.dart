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
      print('Isaak could not get image url');
      return null;
    }
  }

  Future<void> uploadUser({@required User user}) async {
    try {
      _fireStore.collection('users').document(user.email).setData({
        'username': user.username,
        'email': user.email,
        'supplyHashtags': user.skillHashtags,
        'demandHashtags': user.wishHashtags,
        'skillRate': user.skillRate,
        'wishRate': user.wishRate
      });
    } catch (e) {
      print('Isaak could not upload user info');
    }
  }

  Future<User> getUser({@required String userID}) async {
    try {
      print('userID = $userID');
      var userDocument =
          await _fireStore.collection('users').document(userID).get();
      if (userDocument.data == null) {
        print('Isaak could not get user info1');
      }

      return User.fromMap(map: userDocument.data);
    } catch (e) {
      print('Isaak could not get user info2');
      return null;
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      QuerySnapshot snapshot =
          await _fireStore.collection('users').getDocuments();
      List<User> listOfUsers = [];
      for (var document in snapshot.documents) {
        if (document != null) {
          listOfUsers.add(User.fromMap(map: document.data));
        }
      }
      return listOfUsers;
    } catch (e) {
      print('Isaak could not get all the users');
      return null;
    }
  }

  Stream<QuerySnapshot> getUsersStream() {
    try {
      var userSnapshots = _fireStore.collection('users').snapshots();
      return userSnapshots;
    } catch (e) {
      print('Isaak could not get stream of users');
      return null;
    }
  }
}

class User {
  String username;
  String email;
  String skillHashtags;
  String wishHashtags;
  int skillRate;
  int wishRate;

  User(
      {this.username,
      this.email,
      this.skillHashtags,
      this.wishHashtags,
      this.skillRate,
      this.wishRate});

  User.fromMap({Map<String, dynamic> map}) {
    this.username = map['username'];
    this.email = map['email'];
    this.skillHashtags = map['supplyHashtags'];
    this.wishHashtags = map['wishHashtags'];
    this.skillRate = map['skillRate'];
    this.wishRate = map['wishRate'];
  }
}
