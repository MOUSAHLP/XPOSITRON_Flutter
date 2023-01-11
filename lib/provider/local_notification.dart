import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

sendNotification(
    {int id = 0, String? title, String? body, String? image}) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  ////Set the settings for various platform
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
    '@mipmap/launcher_icon',
  );
  const IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload) {
    // Navigator.of(context).pushReplacementNamed("routeName");
  });

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      '1', 'X-POSITRON اشعارات',
      description: "X-POSITRON اشعارات و تنبيهات تطبيق",
      importance: Importance.max,
      enableVibration: true,
      playSound: true);

  flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      await _notificationDetails(
          channel.id, channel.name, channel.description, image));
}

Future _notificationDetails(id, name, description, image) async {
  final largeIconPath = await Utils.downloadFile("$image", "Notification1");
  final bigPicturePath = await Utils.downloadFile("$image", "Notification2");

  final styleInformation = BigPictureStyleInformation(
    FilePathAndroidBitmap(bigPicturePath),
    htmlFormatContentTitle: true,
    htmlFormatTitle: true,
    htmlFormatContent: true,
    largeIcon: FilePathAndroidBitmap(
      largeIconPath,
    ),
  );
  return NotificationDetails(
    android: AndroidNotificationDetails(id, name,
        priority: Priority.high,
        importance: Importance.max,
        color: Colors.blue,
        largeIcon: FilePathAndroidBitmap(
          largeIconPath,
        ),
        styleInformation: BigTextStyleInformation("",
            htmlFormatTitle: true, htmlFormatContent: true),
        channelDescription: description),
  );
}

void noImageNotification({int id = 0, String? title, String? body}) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  ////Set the settings for various platform
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
    '@mipmap/launcher_icon',
  );
  const IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload) {
    // Navigator.of(context).pushReplacementNamed("routeName");
  });

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      '1', 'X-POSITRON اشعارات',
      description: "X-POSITRON اشعارات و تنبيهات تطبيق",
      importance: Importance.max,
      enableVibration: true,
      playSound: true);

  flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            priority: Priority.high,
            importance: Importance.max,
            fullScreenIntent: true,
            styleInformation: BigTextStyleInformation("$body",
                htmlFormatContent: true,
                htmlFormatBigText: true,
                htmlFormatContentTitle: true),
            color: Colors.blue,
            channelDescription: channel.description),
      ));
}

class Utils {
  static Future<String> downloadFile(url, fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/$fileName";
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
