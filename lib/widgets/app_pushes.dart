import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppPushes extends StatefulWidget {
  AppPushes({
    @required this.child,
  });

  final Widget child;

  @override
  _AppPushesState createState() => _AppPushesState();
}

class _AppPushesState extends State<AppPushes> {

  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  initState() {
    super.initState();
    _initLocalNotifications();
    _initFirebaseMessaging();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  _initLocalNotifications() {
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  _initFirebaseMessaging() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('AppPushes onMessage : $message');
        _showNotification(message);
        return;
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> message) {
        print('AppPushs onResume : $message');
        if (Platform.isIOS) {
          _showNotification(message);
        }
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        print('AppPushs onLaunch : $message');
        return;
      },
    );
    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  // TOP-LEVEL or STATIC function to handle background messages
  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    print('AppPushs myBackgroundMessageHandler : $message');
    _showNotification(message);
    return Future<void>.value();
  }

  static Future _showNotification(Map<String, dynamic> message) async {
    var pushTitle;
    var pushText;
    var action;

    if (Platform.isAndroid) {
      var nodeData = message['data'];
      pushTitle = nodeData['title'];
      pushText = nodeData['body'];
      action = nodeData['action'];
    } else {
      pushTitle = message['title'];
      pushText = message['body'];
      action = message['action'];
    }
    print("AppPushs params pushTitle : $pushTitle");
    print("AppPushs params pushText : $pushText");
    print("AppPushs params pushAction : $action");

    // @formatter:off
    var platformChannelSpecificsAndroid = new AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        'your channel description',
        playSound: false,
        enableVibration: false,
        importance: Importance.Max,
        priority: Priority.High);
    // @formatter:on
    var platformChannelSpecificsIos = new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(platformChannelSpecificsAndroid, platformChannelSpecificsIos);

    new Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        pushTitle,
        pushText,
        platformChannelSpecifics,
        payload: 'No_Sound',
      );
    });
  }
}