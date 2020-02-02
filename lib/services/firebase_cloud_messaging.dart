import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Flowby/screens/chat_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseCloudMessaging {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  BuildContext _context;

  void getContext(BuildContext context) {
    _context = context;
  }

  Future<String> getToken() {
    return _firebaseMessaging.getToken();
  }

  void firebaseCloudMessagingListeners(BuildContext context) {
    if (Platform.isIOS) iOSPermission();

//    _firebaseMessaging.getToken().then((token) {
//      //print('token: $token');
//    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> mapMessage) async {
        print('on message $mapMessage');
        CloudMessage message = CloudMessage.fromMap(mapMessage: mapMessage);
        flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails()
            .then((notificationAppLaunchDetails) {
          if (notificationAppLaunchDetails.didNotificationLaunchApp)
            navigateToChat(context: context, message: message);
        });
        _context = context;
        showNotification(message: message);
      },
      onResume: (Map<String, dynamic> mapMessage) async {
        print('on resume $mapMessage');
        CloudMessage message = CloudMessage.fromMap(mapMessage: mapMessage);
        navigateToChat(context: context, message: message);
      },
      onLaunch: (Map<String, dynamic> mapMessage) async {
        print('on launch $mapMessage');
        CloudMessage message = CloudMessage.fromMap(mapMessage: mapMessage);
        navigateToChat(context: context, message: message);
      },
    );
    // Flutter Local Notifications //
    configLocalNotification(context);
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
  }

// Flutter Local Notifications //
  void configLocalNotification(BuildContext context) {
    var initializationSettingsAndroid = new AndroidInitializationSettings(
        'app_icon'); // init app_icon that is on the folder android/app/src/main/res/drawable
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void showNotification({@required CloudMessage message}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message.title,
      message.body,
      platformChannelSpecifics,
      payload: message.string,
    );
  }

  void navigateToChat({
    BuildContext context,
    CloudMessage message,
  }) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute<void>(
        builder: (context) {
          return ChatScreen(
            loggedInUid: message.data['loggedInUser'],
            otherUid: message.data['otherUid'],
            otherUsername: message.data['otherUsername'],
            heroTag: message.data['otherUid'] + 'chats',
            otherImageFileName: message.data['otherImageFileName'],
            chatPath: message.data['chatPath'],
          );
        },
      ),
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      //debugPrint('notification payload: ' + payload);
    }
    CloudMessage message =
        CloudMessage.fromMap(mapMessage: json.decode(payload));
    navigateToChat(context: _context, message: message);
  }
}

class CloudMessage {
  String title;
  String body;
  String priority = 'high';

  String string;

  // click_action = FLUTTER_NOTIFICATION_CLICK is needed otherwise the plugin will be unable to deliver the notification to your app when the users clicks on it in the system tray.
  Map<String, String> data = {
    "click_action": "FLUTTER_NOTIFICATION_CLICK",
    "id": "1",
    "status": "done"
  };
  String toToken;

  CloudMessage({this.title, this.body});

  // {"notification": {"body": "this is a body","title": "this is a title"},
  // "priority": "high",
  // "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "id": "1", "status": "done"},
  // "to": "<FCM TOKEN>"}';
  CloudMessage.fromMap({Map<String, dynamic> mapMessage}) {
    string = JsonEncoder.withIndent("    ").convert(mapMessage);
    title = mapMessage['notification']['title'];
    body = mapMessage['notification']['body'];
    toToken = mapMessage['to'];
    data['screen'] = mapMessage['data']['screen'];
    data['loggedInUid'] = mapMessage['data']['loggedInUid'];
    data['otherUid'] = mapMessage['data']['otherUid'];
    data['otherUsername'] = mapMessage['data']['otherUsername'];
    data['otherImageFileName'] = mapMessage['data']['otherImageFileName'];
    data['chatPath'] = mapMessage['data']['chatPath'];
  }
}
