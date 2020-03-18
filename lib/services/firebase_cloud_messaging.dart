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

  BuildContext context;

  Future<String> getToken() {
    return _firebaseMessaging.getToken();
  }

  void firebaseCloudMessagingListeners(BuildContext context) {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> mapMessage) async {
        this.context = context;
        CloudMessage message = CloudMessage.fromMap(mapMessage: mapMessage);
        showNotification(message: message);
      },
      onResume: (Map<String, dynamic> mapMessage) async {
        CloudMessage message = CloudMessage.fromMap(mapMessage: mapMessage);
        navigateToChat(context, message);
      },
      onLaunch: (Map<String, dynamic> mapMessage) async {
        CloudMessage message = CloudMessage.fromMap(mapMessage: mapMessage);
        navigateToChat(context, message);
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
    String groupKey = 'co.flowby';
    String groupChannelId = 'grouped channel id';
    String groupChannelName = 'grouped channel name';
    String groupChannelDescription = 'grouped channel description';

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      groupChannelId,
      groupChannelName,
      groupChannelDescription,
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
      groupKey: groupKey,
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      message.string.hashCode,
      message.title,
      message.body,
      platformChannelSpecifics,
      payload: message.string,
    );
    print(message.string.hashCode);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      //debugPrint('notification payload: ' + payload);
    }
    debugPrint('context messaging: $context');
    CloudMessage message =
        CloudMessage.fromMap(mapMessage: json.decode(payload));
    navigateToChat(context, message);
  }

  void navigateToChat(
    BuildContext context,
    CloudMessage message,
  ) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute<void>(
        builder: (context) {
          return ChatScreen(
            loggedInUid: message.data['loggedInUid'],
            otherUid: message.data['otherUid'],
            otherUsername: message.data['otherUsername'],
            heroTag: message.data['otherUid'] + 'chats',
            otherImageFileName: message.data['otherImageFileName'],
            otherImageVersionNumber:
                int.parse(message.data['otherImageVersionNumber']),
            // this is a random number for now, it should be otherImageVersionNumber
            chatPath: message.data['chatPath'],
          );
        },
      ),
    );
  }
}

class CloudMessage {
  String title;
  String body;
  String priority = 'high';
  String string;
  String toToken;

  CloudMessage({this.title, this.body});

  // click_action = FLUTTER_NOTIFICATION_CLICK is needed otherwise the plugin will be unable to deliver the notification to your app when the users clicks on it in the system tray.
  Map<String, dynamic> data = {
    "click_action": "FLUTTER_NOTIFICATION_CLICK",
    "id": "1",
    "status": "done"
  };

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
    data['otherImageVersionNumber'] =
        mapMessage['data']['otherImageVersionNumber'];
    data['chatPath'] = mapMessage['data']['chatPath'];
  }
}
