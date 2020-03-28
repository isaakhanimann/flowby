import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Flowby/screens/chat_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

StreamController<int> ctrlUnreadMessages = StreamController<int>();
StreamController<Map<String, List<String>>> ctrlListOfMessages =
    StreamController<Map<String, List<String>>>();

class FirebaseCloudMessaging {
  BuildContext context;

  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<String> getToken() {
    return _firebaseMessaging.getToken();
  }

  void cancelAll() {
    _flutterLocalNotificationsPlugin.cancelAll();
  }


  void firebaseCloudMessagingListeners(BuildContext context) {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> mapMessage) async {
        this.context = context;
        CloudMessage message = CloudMessage.fromMap(mapMessage: mapMessage);
        showNotification(message: message);
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> mapMessage) async {
        CloudMessage message = CloudMessage.fromMap(mapMessage: mapMessage);
        navigateToChat(context, message);
        showNotification(message: message);
      },
      onLaunch: (Map<String, dynamic> mapMessage) async {
        CloudMessage message = CloudMessage.fromMap(mapMessage: mapMessage);
        navigateToChat(context, message);
        showNotification(message: message);
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
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

   Future showNotification({@required CloudMessage message}) async {
    String contentTitle;

/*
    if (messages[message.data['otherUid']] == null ||
        messages[message.data['otherUid']].last == "empty") {
      messages[message.data['otherUid']] = [];
    }
    messages[message.data['otherUid']].add(message.body);
    messages[message.data['otherUid']].length == 1
        ? contentTitle = message.title
        : contentTitle =
            '${message.title} (${messages[message.data['otherUid']].length} messages)';
    print(messages);
    ctrlListOfMessages.add(messages);

    add(messages);
*/
/*
    InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        messages[message.data['otherUid']],
        contentTitle: contentTitle,
        summaryText: message.title);
*/

    String groupKey = 'co.flowby';
//    String groupChannelId = 'message_notifications_id';
    String groupChannelId = 'default_notification_channel_id';
    String groupChannelName = 'Message notifications';
    String groupChannelDescription = 'Sound and pop-up';

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      groupChannelId,
      groupChannelName,
      groupChannelDescription,
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
      groupKey: groupKey,
      category: "Chats",
      setAsGroupSummary: true,
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      message.data['otherUid'].hashCode,
      contentTitle,
      message.body,
      platformChannelSpecifics,
      payload: message.string,
    );
  }
  static Future showNotificationBackground({@required CloudMessage message}) async {
    String contentTitle;
/*
    InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        messages[message.data['otherUid']],
        contentTitle: contentTitle,
        summaryText: message.title);
*/

    String groupKey = 'co.flowby';
//    String groupChannelId = 'message_notifications_id';
    String groupChannelId = 'default_notification_channel_id';
    String groupChannelName = 'Message notifications';
    String groupChannelDescription = 'Sound and pop-up';

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      groupChannelId,
      groupChannelName,
      groupChannelDescription,
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
      groupKey: groupKey,
      category: "Chats",
      setAsGroupSummary: true,
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      message.data['otherUid'].hashCode,
      contentTitle,
      message.body,
      platformChannelSpecifics,
      payload: message.string,
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      //debugPrint('notification payload: ' + payload);
    }
    BuildContext context = this.context;
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

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> mapMessage) async {
    CloudMessage message = CloudMessage.fromMap(mapMessage: mapMessage);
    showNotificationBackground(message: message);
    print('mybackground Message handler');
    if (mapMessage.containsKey('data')) {
      // Handle data message
      final dynamic data = mapMessage['data'];
      print(data);
    }

    if (mapMessage.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = mapMessage['notification'];
      print(notification);
    }

    return;
    // Or do other work.
  }
}

class CloudMessage {
  String title;
  String body;
  String priority = 'high';
  String string;
  String toToken;
  String sound;

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
    toToken = mapMessage['to'];
    title = mapMessage['data']['title'];
    body = mapMessage['data']['body'];
    sound = mapMessage['data']['sound'];
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
