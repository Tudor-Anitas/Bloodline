import 'package:BloodLine/main.dart';
import 'package:BloodLine/screens/maps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class LocalNotifications {

  FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  void initializing() async{
    androidInitializationSettings = AndroidInitializationSettings('app_notif_icon');
    iosInitializationSettings = IOSInitializationSettings();
    initializationSettings = InitializationSettings(androidInitializationSettings, iosInitializationSettings);

    await localNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: goToMap,
    );
  }

  void showNotification(DateTime reservedDate) async{
    await _notification(reservedDate);
  }

  Future<void> _notification(DateTime reservedDate) async{
    // Subtract a day from the reservedDate to remind the user about the donation
    var timeToDeliver = reservedDate.subtract(Duration(days: 1));

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'Channel ID',
        'Channel title',
        'channel body',
        priority: Priority.High,
        importance: Importance.Max,
        ticker: 'test'
    );
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await localNotificationsPlugin.schedule(
        0,
        "Don't forget about the cause!",
        "Click to show the nearest transfusion center",
        timeToDeliver,
        notificationDetails
    );
  }

  Future goToMap(String payload){
    if(payload != null){
      debugPrint('notification payload: $payload');
    }
    // set the navigator to the google maps
    Get.to(Maps());
  }
}