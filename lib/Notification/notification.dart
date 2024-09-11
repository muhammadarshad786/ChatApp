import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:internship_firebase/Screens/show.dart';
import 'package:internship_firebase/main.dart';

class PushNotificationFireBase {
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin localNotification = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      sound: true,
      badge: true,
      provisional: false,
      carPlay: false,
    );
    await getDeviceToken();
  }

  static Future<void> getDeviceToken() async {
    String? device = await firebaseMessaging.getToken();
    print('Device Token: $device');
  }

  Future<void> localInit() async {
    AndroidInitializationSettings settings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    
    var initializationSetting = InitializationSettings(
      android: settings,
      // iOS: DarwinInitializationSettings(
      //   requestAlertPermission: true,
      //   requestBadgePermission: true,
      //   requestSoundPermission: true,
      //   onDidReceiveLocalNotification: (id, String? title, String? body, String? payload) async {},
      // ),
    );

    await localNotification.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        _onClickNotificationHandle(notificationResponse);
      },
    );

    // Set up foreground message handling
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Set up background/terminated message handling
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    FirebaseMessaging.instance.getInitialMessage().then(_handleTerminatedMessage);
  }

  Future<NotificationDetails> notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel-Id', 'channel-Name', importance: Importance.max),
      // iOS: DarwinNotificationDetails()
    );
  }

  Future<void> showNotification({int id = 10, String? title, String? payload, String? body}) async {
    return localNotification.show(id, title, body, await notificationDetails(), payload: payload);
  }

  // void _onClickNotificationHandle(NotificationResponse response) {
  //   final payload = response.payload ?? 'No Payload';
  //   final body = response.notification?.body ?? 'No Body';
  //   final title = response.notification?.title ?? 'No Title';

  //   final Map<String, dynamic> data = payload.isNotEmpty ? jsonDecode(payload) : {};

  //   MyApp.navigatorKey.currentState?.push(MaterialPageRoute(
  //     builder: (context) => ShowScreen(
  //       title: data['title'] ?? title,
  //       body: data['body'] ?? body,
  //       payload: payload,
  //     ),
  //   ));
  // }
  void _onClickNotificationHandle(NotificationResponse response) {
  final payload = response.payload ?? 'No Payload';
  final String notificationBody = response.payload ?? 'No Body';
  final String notificationTitle = 'Notification';

  final Map<String, dynamic> data = payload.isNotEmpty ? jsonDecode(payload) : {};

  MyApp.navigatorKey.currentState?.push(MaterialPageRoute(
    builder: (context) => ShowScreen(
      title: data['title'] ?? notificationTitle,
      body: data['body'] ?? notificationBody,
      payload: payload,
    ),
  ));
}

  void _handleForegroundMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      showNotification(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        payload: jsonEncode(message.data),
      );
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    _navigateToShowScreen(message);
  }

  void _handleTerminatedMessage(RemoteMessage? message) {
    if (message != null) {
      _navigateToShowScreen(message);
    }
  }

  void _navigateToShowScreen(RemoteMessage message) {
    MyApp.navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (context) => ShowScreen(
        title: message.notification?.title ?? 'No Title',
        body: message.notification?.body ?? 'No Body',
        payload: jsonEncode(message.data),
      ),
    ));
  }
}