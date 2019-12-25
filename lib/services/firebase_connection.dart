import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:float/models/message.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/navigation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

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

  static Stream<List<User>> getUsersStream(
      {@required FirebaseUser loggedInUser}) {
    try {
      var userSnapshots = _fireStore.collection('users').snapshots().map(
          (snap) => snap.documents
              .map((doc) => User.fromMap(map: doc.data))
              .where((user) => user.email != loggedInUser.email)
              .toList());
      return userSnapshots;
    } catch (e) {
      print('Isaak could not get stream of users');
      return null;
    }
  }

  static Stream<List<User>> getUsersStreamWithDistance(
      {@required User loggedInUser}) {
    try {
      var userSnapshots = _fireStore.collection('users').snapshots().map(
          (snap) => snap.documents
                  .map((doc) => User.fromMap(map: doc.data))
                  .where((user) => user.email != loggedInUser.email)
                  .map((user) {
                user.updateDistanceToOtherUser(otherUser: loggedInUser);
                return user;
              }).toList());
      return userSnapshots;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Stream<List<User>> getSpecifiedUsersStreamWithDistance(
      {@required User loggedInUser, @required List<String> uids}) {
    try {
      List<Stream<User>> listOfStreams = [];
      for (var uid in uids) {
        Stream<User> streamToAdd = _fireStore
            .collection('users')
            .where('email', isEqualTo: uid)
            .snapshots()
            .map((snap) => snap.documents
                    .map((doc) => User.fromMap(map: doc.data))
                    .map((user) {
                  user.updateDistanceToOtherUser(otherUser: loggedInUser);
                  return user;
                }).toList()[0]);
        listOfStreams.add(streamToAdd);
      }

      Stream<List<User>> usersStream = ZipStream.list(listOfStreams);

      return usersStream;
    } catch (e) {
      print('Isaak could not get specified stream of users');
      print(e);
      return null;
    }
  }

  static Stream<List<User>> getSpecifiedUsersStream(
      {@required List<String> uids}) {
    try {
      List<Stream<User>> listOfStreams = [];
      for (var uid in uids) {
        Stream<User> streamToAdd = _fireStore
            .collection('users')
            .where('email', isEqualTo: uid)
            .snapshots()
            .map((snap) => snap.documents
                .map((doc) => User.fromMap(map: doc.data))
                .toList()[0]);
        listOfStreams.add(streamToAdd);
      }

      Stream<List<User>> usersStream = ZipStream.list(listOfStreams);

      return usersStream;
    } catch (e) {
      print('Isaak could not get specified stream of users');
      return null;
    }
  }

  static Stream<User> getSpecifiedUserStream({@required String uid}) {
    try {
      Stream<User> userStream = _fireStore
          .collection('users')
          .where('email', isEqualTo: uid)
          .snapshots()
          .map((snap) => snap.documents
              .map((doc) => User.fromMap(map: doc.data))
              .toList()[0]);

      return userStream;
    } catch (e) {
      print('Isaak could not get stream of the specified user');
      return null;
    }
  }

  static Future<List<String>> getUidsOfUsersInChats(
      {@required String loggedInUser}) async {
    List<String> uids = [];
    QuerySnapshot snap1 = await _fireStore
        .collection('chats')
        .where('user1', isEqualTo: loggedInUser)
        .getDocuments();
    QuerySnapshot snap2 = await _fireStore
        .collection('chats')
        .where('user2', isEqualTo: loggedInUser)
        .getDocuments();

    for (var doc in snap1.documents) {
      uids.add(doc.data['user2']);
    }
    for (var doc in snap2.documents) {
      uids.add(doc.data['user1']);
    }

    return uids;
  }

  static Future<String> getChatPath(
      {@required String user, @required String otherUser}) async {
    try {
      String chatPath;
      QuerySnapshot snap1 = await _fireStore
          .collection('chats')
          .where('user1', isEqualTo: user)
          .where('user2', isEqualTo: otherUser)
          .getDocuments();
      QuerySnapshot snap2 = await _fireStore
          .collection('chats')
          .where('user1', isEqualTo: otherUser)
          .where('user2', isEqualTo: user)
          .getDocuments();
      if (snap1.documents.isNotEmpty) {
        //loggedInUser is user1
        chatPath = snap1.documents[0].reference.path;
      } else if (snap2.documents.isNotEmpty) {
        //loggedInUser is user2
        chatPath = snap2.documents[0].reference.path;
      } else {
        //there is no chat yet, so create one
        chatPath = await _createChat(user: user, otherUser: otherUser);
      }
      return chatPath;
    } catch (e) {
      print('Isaak could not get chatpath');
      return null;
    }
  }

  static Future<String> _createChat(
      {@required String user, @required String otherUser}) async {
    try {
      var docReference = await _fireStore.collection('chats').add({
        'user1': user,
        'user2': otherUser,
      });
      return docReference.path;
    } catch (e) {
      print('Isaak could not createChat');
      return null;
    }
  }

  static Stream<List<Message>> getMessageStream({@required String chatPath}) {
    try {
      var messageStream = _fireStore
          .document(chatPath)
          .collection('messages')
          .orderBy('timestamp')
          .snapshots()
          .map((snap) => snap.documents.reversed
              .map((doc) => Message.fromMap(map: doc.data))
              .toList());
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

  static void uploadUsersLocation(
      {@required String userEmail, @required Position position}) {
    try {
      _fireStore.collection('users').document(userEmail).updateData({
        'location': GeoPoint(position.latitude, position.longitude)
//        , 'locationTimestamp': position.timestamp
      });
    } catch (e) {
      print('Isaak could not upload position info');
    }
  }
}
