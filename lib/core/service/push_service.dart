import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moveme/core/base/base_service.dart';
import 'package:moveme/core/bloc/app/app_event.dart';
import 'package:moveme/core/model/push_message.dart';
import 'package:moveme/locator.dart';

class PushService extends BaseService {
  FirebaseMessaging _firebaseMessaging;
  FlutterLocalNotificationsPlugin _localNotifications;

  String token;

  PushService() {
    _firebaseMessaging = FirebaseMessaging();
    _localNotifications = FlutterLocalNotificationsPlugin();
  }

  Future<void> initialize() async {
    //FIREBASE
    _firebaseMessaging
        .requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {});

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) => _onMessage(message, false),
        onLaunch: (Map<String, dynamic> message) => _onMessage(message, true),
        onResume: (Map<String, dynamic> message) => _onMessage(message, true));

    //LOCAL NOTIFICATION
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS =
        new IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initializationSettings =
        new InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await _localNotifications.initialize(initializationSettings, onSelectNotification: onSelectNotification);

    this.token = await _firebaseMessaging.getToken();

    await _firebaseMessaging.subscribeToTopic('all');
    await _firebaseMessaging.subscribeToTopic(Platform.isIOS ? 'ios' : 'android');
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    print(id);
  }

  Future<dynamic> appBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      final dynamic notification = message['notification'];
    }
  }

  Future<void> _onMessage(Map<String, dynamic> message, bool isBackground) {
    PushMessage push;
    if (message['data'] == null) {
      push = new PushMessage.toBackground(message);
    } else if (message['data'].isEmpty) {
      push = new PushMessage.toNotification(message['notification']);
    } else {
      push = PushMessage.toPush(message);
    }
    push.isBackground = isBackground;
    eventBus.fire(AppNewMessageEvent(push));
  }

  Future showNotification(PushMessage push) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails('0', '0', '0',
        importance: Importance.max, priority: Priority.high, icon: 'app_icon');

    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await _localNotifications.show(0, push.title, push.body, platformChannelSpecifics, payload: push.toString());
  }

  Future showNotificationMessage(String title, String message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails('0', '0', '0',
        importance: Importance.max, priority: Priority.high, icon: 'app_icon');

    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await _localNotifications.show(0, title, message, platformChannelSpecifics, payload: '');
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      var push = PushMessage.toNotification(json.decode(payload));
      push.isBackground = true;
      eventBus.fire(AppNewMessageEvent(push));
    }
  }
}
