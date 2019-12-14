import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:float/models/message.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/navigation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _fireStore = Firestore.instance;
final _auth = FirebaseAuth.instance;
final StorageReference _storageReference = FirebaseStorage().ref();

class FirebaseConnection {
  static Future<FirebaseUser> getCurrentUser() async {
    final user = await _auth.currentUser();
    return user;
  }

  static Future<void> signOut() async {
    _auth.signOut();
  }

  static Future<AuthResult> signIn(
      {@required String email, @required String password}) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> autoLogin({@required BuildContext context}) async {
    final user = await _auth.currentUser();
    if (user != null) {
      Navigator.pushNamed(context, NavigationScreens.id);
    }
  }

  static Stream<FirebaseUser> getAuthenticationStream() {
    return _auth.onAuthStateChanged;
  }

  static Future<AuthResult> createUser(
      {@required String email, @required String password}) async {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  static Future<void> uploadImage(
      {@required String fileName, @required File image}) async {
    try {
      final StorageUploadTask uploadTask =
          _storageReference.child('images/$fileName').putFile(image);
      await uploadTask.onComplete;
    } catch (e) {
      print('Isaak could not upload image');
    }
  }

  static Future<String> getImageUrl({@required String fileName}) async {
    try {
      final String downloadUrl =
          await _storageReference.child('images/$fileName').getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Isaak could not get image url');
      return null;
    }
  }

  static Future<void> uploadUser({@required User user}) async {
    try {
      _fireStore.collection('users').document(user.email).setData({
        'username': user.username,
        'email': user.email,
        'skillHashtags': user.skillHashtags,
        'wishHashtags': user.wishHashtags,
        'skillRate': user.skillRate,
        'wishRate': user.wishRate
      });
    } catch (e) {
      print('Isaak could not upload user info');
    }
  }

  static Future<User> getUser({@required String userID}) async {
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

  static Future<List<User>> getAllUsers() async {
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

  static Stream<QuerySnapshot> getUsersStream() {
    try {
      var userSnapshots = _fireStore.collection('users').snapshots();
      return userSnapshots;
    } catch (e) {
      print('Isaak could not get stream of users');
      return null;
    }
  }

  static Future<String> getChatPath(
      {@required String user, @required String otherUser}) async {
    try {
      String chatPath;
      QuerySnapshot snapshot1 = await _fireStore
          .collection('chats')
          .where('user1', isEqualTo: user)
          .where('user2', isEqualTo: otherUser)
          .getDocuments();
      QuerySnapshot snapshot2 = await _fireStore
          .collection('chats')
          .where('user1', isEqualTo: otherUser)
          .where('user2', isEqualTo: user)
          .getDocuments();
      if (snapshot1.documents.isNotEmpty) {
        //loggedInUser is user1
        chatPath = snapshot1.documents[0].reference.path;
      } else if (snapshot2.documents.isNotEmpty) {
        //loggedInUser is user2
        chatPath = snapshot2.documents[0].reference.path;
      } else {
        //there is no chat yet
      }
      return chatPath;
    } catch (e) {
      print('Isaak could not get chatpath');
    }
    return null;
  }

  static void createChat({@required String user, @required String otherUser}) {
    try {
      _fireStore.collection('chats').add({
        'user1': user,
        'user2': otherUser,
      });
    } catch (e) {
      print('Isaak could not createChat');
    }
  }

  static Stream<QuerySnapshot> getMessageStream({@required String chatPath}) {
    try {
      var messageStream = _fireStore
          .document(chatPath)
          .collection('messages')
          .orderBy('timestamp')
          .snapshots();
      return messageStream;
    } catch (e) {
      print('Isaak could not get the message stream');
    }
    return Stream.empty();
  }

  static void uploadMessage(
      {@required String chatPath, @required Message message}) {
    try {
      _fireStore.document(chatPath).collection('messages').add(
        {
          'text': message.text,
          'sender': message.sender,
          'timestamp': message.timestamp,
        },
      );
    } catch (e) {
      print('Isaak could not upload message');
    }
  }
}
