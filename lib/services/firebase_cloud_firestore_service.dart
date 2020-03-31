import 'dart:async';

import 'package:Flowby/models/announcement.dart';
import 'package:Flowby/models/chat.dart';
import 'package:Flowby/models/message.dart';
import 'package:Flowby/models/unread_messages.dart';
import 'package:Flowby/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
      print('Could not upload user info');
      debugPrint('error: $e');
    }
  }

  Future<User> getUser({@required String uid}) async {
    try {
      var userDocument =
          await _fireStore.collection('users').document(uid).get();
      if (userDocument.data == null) {
        print('Could not get user with uid = $uid');
        return null;
      }

      return User.fromMap(map: userDocument.data);
    } catch (e) {
      print('Could not get user info2');
      print(e);
      return null;
    }
  }

  Future<List<Announcement>> getAnnouncements() async {
    try {
      QuerySnapshot snap = await _fireStore
          .collection('announcements')
          .orderBy('timestamp', descending: true)
          .getDocuments();
      List<Announcement> announcements = snap.documents.map((doc) {
        Announcement announcement = Announcement.fromMap(map: doc.data);
        announcement.docId = doc.documentID;
        return announcement;
      }).toList();
      return announcements;
    } catch (e) {
      print('Could not get announcements');
      print(e);
      return null;
    }
  }

  uploadAnnouncement({@required Announcement announcement}) async {
    try {
      await _fireStore.collection('announcements').add(announcement.toMap());
    } catch (e) {
      print('Could not upload announcement');
      print(e);
    }
  }

  deleteAnnouncement({@required Announcement announcement}) async {
    try {
      await _fireStore
          .collection('announcements')
          .document(announcement.docId)
          .delete();
    } catch (e) {
      print('Could not delete announcement');
      print(e);
    }
  }

  Stream<User> getUserStream({@required String uid}) {
    try {
      return _fireStore
          .collection('users')
          .document(uid)
          .snapshots()
          .map((doc) => User.fromMap(map: doc.data));
    } catch (e) {
      print('Could not get the user stream');
    }
    return Stream.empty();
  }

  Stream<ChatWithoutLastMessage> getChatStreamWithoutLastMessageField(
      {@required String chatPath}) {
    try {
      var chatStream = _fireStore.document(chatPath).snapshots().map((doc) {
        Map<dynamic, dynamic> map = doc.data;
        ChatWithoutLastMessage chat = ChatWithoutLastMessage(
            user1: User.fromMap(map: map['user1']),
            hasUser1Blocked: map['hasUser1Blocked'],
            user2: User.fromMap(map: map['user2']),
            hasUser2Blocked: map['hasUser2Blocked'],
            chatpath: doc.reference.path);
        return chat;
      }).distinct(); //use distinct to avoid unnecessary rebuilds
      return chatStream;
    } catch (e) {
      print('Could not get the chat stream');
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
    Stream<List<Chat>> chatStream = _fireStore
        .collection('chats')
        .where('combinedUids', arrayContains: loggedInUid)
        .snapshots()
        .map((snap) => snap.documents.map((doc) {
              Chat chat = Chat.fromMap(map: doc.data);
              chat.setChatpath(chatpath: doc.reference.path);
              return chat;
            }).toList());
    return chatStream;
  }

  Future<String> getChatPath(
      {@required User user1, @required User user2}) async {
    try {
      QuerySnapshot snap = await _fireStore
          .collection('chats')
          .where('combinedUids', arrayContains: user1.uid + user2.uid)
          .getDocuments();
      String chatPath;
      if (snap.documents.length == 0) {
        //there is no chat yet, so create one
        chatPath = await _createChat(user1: user1, user2: user2);
      } else {
        chatPath = snap.documents[0].reference.path;
      }
      return chatPath;
    } catch (e) {
      print(e);
      print('Could not get chatpath');
      return null;
    }
  }

  Future<String> _createChat(
      {@required User user1, @required User user2}) async {
    try {
      Chat chat = Chat(
          combinedUids: [
            user1.uid,
            user2.uid,
            user1.uid + user2.uid,
            user2.uid + user1.uid
          ],
          user1: user1,
          user2: user2,
          hasUser1Blocked: false,
          hasUser2Blocked: false,
          lastMessageText: 'No message yet',
          lastMessageTimestamp: FieldValue.serverTimestamp());
      var docReference = await _fireStore.collection('chats').add(chat.toMap());
      return docReference.path;
    } catch (e) {
      print('Could not createChat');
      print(e);
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
      print('Could not get the message stream');
    }
    return Stream.empty();
  }

  Future<void> uploadMessage(
      {@required String chatPath, @required Message message}) async {
    try {
      await _fireStore
          .document(chatPath)
          .collection('messages')
          .add(message.toMap());
    } catch (e) {
      print('Could not upload message');
    }
  }

  Future<void> uploadUsersLocation(
      {@required uid, @required Position position}) async {
    try {
      await _fireStore.collection('users').document(uid).updateData(
          {'location': GeoPoint(position.latitude, position.longitude)});
    } catch (e) {
      print('Could not upload position info');
    }
  }

  Future<void> uploadUsersPushToken(
      {@required String uid, @required String pushToken}) async {
    try {
      _fireStore
          .collection('users')
          .document(uid)
          .updateData({'pushToken': pushToken});
    } catch (e) {
      print('Could not upload push token');
    }
  }
/*
* Unread Messages Management
* */
  Stream<UnreadMessages> getUnreadMessagesStream({@required String uid}) {
    try {
      return _fireStore
          .collection('users')
          .document(uid)
          .snapshots()
          .map((doc) => UnreadMessages.fromMap(map: doc.data));
    } catch (e) {
      print('Could not get the unread messages stream');
    }
    return Stream.empty();
  }
  // this function is executed when the user leaves the chat
  Future<void> resetUnreadMessagesInChat(
      {@required String chatPath, @required bool isUser1}) async {
    if (isUser1) {
      await _fireStore.document(chatPath).updateData({'unreadMessages1': 0});
    } else {
      await _fireStore.document(chatPath).updateData({'unreadMessages2': 0});
    }
    return null;
  }
  // this function is executed when the user leaves the chat
  Future<void> updateUserTotalUnreadMessages(
      {@required String chatPath, @required bool isUser1, @required String uid}) async {
    String docPath = "users/$uid";
    var chatDoc = await _fireStore.document(chatPath).get();
    var userDoc = await _fireStore.document(docPath).get();

    int readMessages = 0;
    int total = userDoc.data['totalUnreadMessages'];

    if (isUser1) {
      readMessages = chatDoc.data['unreadMessages1'];
    } else {
      readMessages = chatDoc.data['unreadMessages2'];
    }
    int newTotal = total - readMessages;
    await _fireStore.document(docPath).updateData({'totalUnreadMessages': newTotal});
    return null;
  }
}
