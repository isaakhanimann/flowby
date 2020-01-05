import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:float/models/chat.dart';
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

  static Future<void> resetPassword({@required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  static Future<void> autoLogin({@required BuildContext context}) async {
    final user = await _auth.currentUser();
    if (user != null) {
      Navigator.pushNamed(context, NavigationScreen.id);
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
      _fireStore.collection('users').document(user.uid).setData({
        'username': user.username,
        'uid': user.uid,
        'skillHashtags': user.skillHashtags,
        'wishHashtags': user.wishHashtags,
        'skillRate': user.skillRate,
        'wishRate': user.wishRate
      });
    } catch (e) {
      print('Isaak could not upload user info');
    }
  }

  static Future<User> getUser({@required String uid}) async {
    try {
      var userDocument =
          await _fireStore.collection('users').document(uid).get();
      if (userDocument.data == null) {
        print('Isaak could not get user info1');
      }

      return User.fromMap(map: userDocument.data);
    } catch (e) {
      print('Isaak could not get user info2');
      return null;
    }
  }

  static Stream<List<User>> getUsersStream({@required String uid}) {
    try {
      var userSnapshots = _fireStore.collection('users').snapshots().map(
          (snap) => snap.documents
              .map((doc) => User.fromMap(map: doc.data))
              .where((user) => user.uid != uid)
              .toList());
      return userSnapshots;
    } catch (e) {
      print('Isaak could not get stream of users');
      return null;
    }
  }

  static Stream<List<User>> getUsersStreamWithDistance(
      {@required Position position, String uidToExclude}) {
    try {
      var userSnapshots = _fireStore.collection('users').snapshots().map(
          (snap) => snap.documents
                  .map((doc) => User.fromMap(map: doc.data))
                  .where((user) =>
                      (uidToExclude != null) ? user.uid != uidToExclude : true)
                  .map((user) {
                user.updateDistanceToPositionIfPossible(position: position);
                return user;
              }).toList());
      return userSnapshots;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Stream<List<User>> getSpecifiedUsersStreamWithDistance(
      {@required Position position, @required List<String> uids}) {
    try {
      List<Stream<User>> listOfStreams = [];
      for (var uid in uids) {
        Stream<User> streamToAdd = _fireStore
            .collection('users')
            .where('uid', isEqualTo: uid)
            .snapshots()
            .map((snap) => snap.documents
                    .map((doc) => User.fromMap(map: doc.data))
                    .map((user) {
                  user.updateDistanceToPositionIfPossible(position: position);
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
            .where('uid', isEqualTo: uid)
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

  static Stream<User> getUserStream({@required String uid}) {
    try {
      Stream<User> userStream = _fireStore
          .collection('users')
          .where('uid', isEqualTo: uid)
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

  static Stream<List<Chat>> getChatStream({@required String loggedInUid}) {
    Stream<List<Chat>> stream1 = _fireStore
        .collection('chats')
        .where('uid1', isEqualTo: loggedInUid)
        .snapshots()
        .map((snap) => snap.documents.map((doc) {
              Chat chat = Chat.fromMap(map: doc.data);
              chat.setChatpath(chatpath: doc.reference.path);
              return chat;
            }).toList());
    Stream<List<Chat>> stream2 = _fireStore
        .collection('chats')
        .where('uid2', isEqualTo: loggedInUid)
        .snapshots()
        .map((snap) => snap.documents.map((doc) {
              Chat chat = Chat.fromMap(map: doc.data);
              chat.setChatpath(chatpath: doc.reference.path);
              return chat;
            }).toList());

    //i have 2 streams of lists
    //i want one stream with the list of those streams combined

    Stream<List<Chat>> chatStream =
        ZipStream.zip2(stream1, stream2, (list1, list2) => list1 + list2);

    return chatStream;
  }

  static Future<String> getChatPath(
      {@required String loggedInUid,
      @required String loggedInUsername,
      @required String otherUid,
      @required String otherUsername}) async {
    try {
      String chatPath;
      QuerySnapshot snap1 = await _fireStore
          .collection('chats')
          .where('uid1', isEqualTo: loggedInUid)
          .where('uid2', isEqualTo: otherUid)
          .getDocuments();
      QuerySnapshot snap2 = await _fireStore
          .collection('chats')
          .where('uid1', isEqualTo: otherUid)
          .where('uid2', isEqualTo: loggedInUid)
          .getDocuments();
      if (snap1.documents.isNotEmpty) {
        //loggedInUser is user1
        chatPath = snap1.documents[0].reference.path;
      } else if (snap2.documents.isNotEmpty) {
        //loggedInUser is user2
        chatPath = snap2.documents[0].reference.path;
      } else {
        //there is no chat yet, so create one
        chatPath = await _createChat(
            loggedInUserUid: loggedInUid,
            loggedInUsername: loggedInUsername,
            otherUserUid: otherUid,
            otherUsername: otherUsername);
      }
      return chatPath;
    } catch (e) {
      print('Isaak could not get chatpath');
      return null;
    }
  }

  static Future<String> _createChat(
      {@required String loggedInUserUid,
      @required String loggedInUsername,
      @required String otherUserUid,
      @required String otherUsername}) async {
    try {
      var docReference = await _fireStore.collection('chats').add({
        'uid1': loggedInUserUid,
        'username1': loggedInUsername,
        'uid2': otherUserUid,
        'username2': otherUsername,
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
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
          'sender': message.senderUid,
          'timestamp': message.timestamp,
        },
      );
    } catch (e) {
      print('Isaak could not upload message');
    }
  }

  static void uploadUsersLocation(
      {@required String uid, @required Position position}) {
    try {
      _fireStore.collection('users').document(uid).updateData({
        'location': GeoPoint(position.latitude, position.longitude)
//        , 'locationTimestamp': position.timestamp
      });
    } catch (e) {
      print('Isaak could not upload position info');
    }
  }
}
