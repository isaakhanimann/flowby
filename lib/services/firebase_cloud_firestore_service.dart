import 'dart:async';

import 'package:Flowby/models/chat.dart';
import 'package:Flowby/models/message.dart';
import 'package:Flowby/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:Flowby/models/chat_without_last_message.dart';

class FirebaseCloudFirestoreService {
  final _fireStore = Firestore.instance;

  Future<void> uploadUser({@required User user}) async {
    try {
      _fireStore
          .collection('users')
          .document(user.uid)
          .setData(user.toMap(), merge: true);
    } catch (e) {
      print('Isaak could not upload user info');
      debugPrint('error: $e');
    }
  }

  Future<User> getUser({@required String uid}) async {
    try {
      var userDocument =
          await _fireStore.collection('users').document(uid).get();
      if (userDocument.data == null) {
        print('Isaak could not get user info1');
        return null;
      }

      return User.fromMap(map: userDocument.data);
    } catch (e) {
      print('Isaak could not get user info2');
      return null;
    }
  }

  Stream<List<User>> getUsersStream({@required String uidToExclude}) {
    try {
      var userSnapshots = _fireStore.collection('users').snapshots().map(
          (snap) => snap.documents
              .map((doc) => User.fromMap(map: doc.data))
              .where((user) =>
                  (uidToExclude != null) ? user.uid != uidToExclude : true)
              .toList());
      return userSnapshots;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<ChatWithoutLastMessage> getChatStreamWithoutLastMessageField(
      {@required String chatPath}) {
    try {
      var chatStream = _fireStore.document(chatPath).snapshots().map((doc) {
        Map<dynamic, dynamic> map = doc.data;
        ChatWithoutLastMessage chat = ChatWithoutLastMessage(
            uid1: map['uid1'],
            username1: map['username1'],
            user1ImageFileName: map['user1ImageFileName'],
            hasUser1Blocked: map['hasUser1Blocked'],
            uid2: map['uid2'],
            username2: map['username2'] ?? 'Default username2',
            user2ImageFileName: map['user2ImageFileName'],
            hasUser2Blocked: map['hasUser2Blocked'],
            chatpath: doc.reference.path);
        return chat;
      }).distinct(); //use distinct to avoid unnecessary rebuilds
      return chatStream;
    } catch (e) {
      print('Isaak could not get the chat stream');
    }
    return Stream.empty();
  }

  Future<void> uploadChatBlocked(
      {@required String chatpath,
      bool hasUser1Blocked,
      bool hasUser2Blocked}) async {
    if (hasUser1Blocked != null) {
      await _fireStore
          .document(chatpath)
          .updateData({'hasUser1Blocked': hasUser1Blocked});
    } else if (hasUser2Blocked != null) {
      await _fireStore
          .document(chatpath)
          .updateData({'hasUser2Blocked': hasUser2Blocked});
    }
    return null;
  }

  Stream<List<Chat>> getChatsStream({@required String loggedInUid}) {
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

  Future<String> getChatPath(
      {@required String loggedInUid,
      @required String otherUid,
      @required String otherUsername,
      @required String otherUserImageFileName}) async {
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
            loggedInUid: loggedInUid,
            otherUserUid: otherUid,
            otherUsername: otherUsername,
            otherUserImageFileName: otherUserImageFileName);
      }
      return chatPath;
    } catch (e) {
      print('Isaak could not get chatpath');
      return null;
    }
  }

  Future<String> _createChat(
      {@required String loggedInUid,
      @required String otherUserUid,
      @required String otherUsername,
      @required String otherUserImageFileName}) async {
    try {
      User loggedInUser = await getUser(uid: loggedInUid);
      Chat chat = Chat(
          uid1: loggedInUser.uid,
          username1: loggedInUser.username,
          user1ImageFileName: loggedInUser.imageFileName,
          hasUser1Blocked: false,
          uid2: otherUserUid,
          username2: otherUsername,
          user2ImageFileName: otherUserImageFileName,
          hasUser2Blocked: false,
          lastMessageText: 'No message yet',
          lastMessageTimestamp: FieldValue.serverTimestamp());
      var docReference = await _fireStore.collection('chats').add(chat.toMap());
      return docReference.path;
    } catch (e) {
      print('Isaak could not createChat');
      return null;
    }
  }

  Stream<List<Message>> getMessageStream({@required String chatPath}) {
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

  void uploadMessage({@required String chatPath, @required Message message}) {
    try {
      _fireStore.document(chatPath).collection('messages').add(
        {
          'text': message.text,
          'senderUid': message.senderUid,
          'receiverUid': message.receiverUid,
          'timestamp': message.timestamp,
        },
      );
    } catch (e) {
      print('Isaak could not upload message');
    }
  }

  void uploadUsersLocation({@required uid, @required Position position}) {
    try {
      _fireStore.collection('users').document(uid).updateData({
        'location': GeoPoint(position.latitude, position.longitude)
//        , 'locationTimestamp': position.timestamp
      });
    } catch (e) {
      print('Isaak could not upload position info');
    }
  }

  void uploadPushToken({@required String uid, @required String pushToken}) {
    try {
      _fireStore
          .collection('users')
          .document(uid)
          .updateData({'pushToken': pushToken});
    } catch (e) {
      print('Isaak could not upload Push Token');
    }
  }

  void uploadProfilePic({@required String uid}) {
    try {
      _fireStore
          .collection('users')
          .document(uid)
          .updateData({'imageFileName': uid});
    } catch (e) {
      print('Isaak could not upload Push Token');
    }
  }
}
