import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseCloudMessaging {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<String> getToken() {
    return _firebaseMessaging.getToken();
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.getToken().then((token) {
      //print('token: $token');
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> mapMessage) async {
        print('on message $mapMessage');
        CloudMessage message = CloudMessage.fromMap(mapMessage: mapMessage);
        showNotification(message: message);
      },
      onResume: (Map<String, dynamic> mapMessage) async {
        print('on resume $mapMessage');
      },
      onLaunch: (Map<String, dynamic> mapMessage) async {
        print('on launch $mapMessage');
      },
    );
    // Flutter Local Notifications //
    configLocalNotification();
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

// Flutter Local Notifications //
  void configLocalNotification() {
    var initializationSettingsAndroid = new AndroidInitializationSettings(
        'app_icon'); // init app_icon that is on the folder android/app/src/main/res/drawable
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
      payload:
          'put data here that will be passed back to the app when a notification is tapped',
    );
  }
}

class CloudMessage {
  String title;
  String body;

  CloudMessage({this.title, this.body});

  CloudMessage.fromMap({Map<String, dynamic> mapMessage}) {
    title = mapMessage['notification']['title'];
    body = mapMessage['notification']['body'];
  }
}
