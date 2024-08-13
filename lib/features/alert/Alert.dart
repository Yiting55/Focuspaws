import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future sendNotification() async {
  FlutterLocalNotificationsPlugin localNotification = new FlutterLocalNotificationsPlugin();
  var androidDetails = new AndroidNotificationDetails(
    "ID", "local notification", "yes!",
    importance: Importance.high);
  var iosDetails = new IOSNotificationDetails(); 
  var generalDetails = new NotificationDetails(
    android: androidDetails,
    iOS: iosDetails);
  await localNotification.show(0, "Focuspaws", 
  "Alert! your pet's health value is below 40!", generalDetails);
}