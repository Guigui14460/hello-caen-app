import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'storage_manager.dart';

/// Service used to push local notification for the user.
class NotificationService extends ChangeNotifier {
  static final String storageKey = "notifications-enabled";

  /// Singleton instance.
  static NotificationService instance;

  static bool enabled;

  /// Notification plugin used to display notifications.
  FlutterLocalNotificationsPlugin plugin;

  /// Map of used ids for notifications and his title.
  Map<int, String> usedIds = {};

  /// Initializes the singleton instance.
  static Future<void> init() async {
    instance = new NotificationService._();
    await StorageManager.exists(storageKey).then((value) async {
      if (!value) {
        await StorageManager.saveData(storageKey, true);
        enabled = true;
      } else {
        StorageManager.readData(storageKey).then((value) {
          enabled = value;
        });
      }
    });
    if (enabled) {
      await _initPlugin();
    }
  }

  static Future<void> _initPlugin() async {
    AndroidInitializationSettings android =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    IOSInitializationSettings iOS = IOSInitializationSettings();
    InitializationSettings initializationSettings =
        InitializationSettings(android: android, iOS: iOS);
    instance.plugin = FlutterLocalNotificationsPlugin();
    await instance.plugin
        .initialize(initializationSettings); // OnSelectNotification available
  }

  /// Private constructor.
  NotificationService._();

  /// Pushes a single notification.
  Future<void> pushNotification(String title, String body) async {
    if (!enabled) {
      throw new Exception("Notifications not enabled");
    }
    AndroidNotificationDetails android = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high);
    IOSNotificationDetails iOS = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: android, iOS: iOS);
    await plugin.show(0, title, body, platformChannelSpecifics,
        payload: "Default_Sound");
  }

  /// Define a schedule notification for a precise date.
  Future<void> scheduledNotification(String androidId, int id, String title,
      String body, DateTime scheduleDateTime) async {
    if (!enabled) {
      throw new Exception("Notifications not enabled");
    }
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      androidId,
      'Reminder notifications',
      'Remember about it',
      icon: 'app_icon',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    addToUsedId(id, title);
    await this.plugin.zonedSchedule(
          id,
          title,
          body,
          scheduleDateTime,
          platformChannelSpecifics,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.wallClockTime,
        );
  }

  /// Define a schedule notification with an interval.
  Future<void> scheduleNotificationPeriodically(String androidId, int id,
      String title, String body, RepeatInterval interval) async {
    if (!enabled) {
      throw new Exception("Notifications not enabled");
    }
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      androidId,
      'Reminder notifications',
      'Remember about it',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    addToUsedId(id, title);
    await plugin.periodicallyShow(
        id, title, body, interval, platformChannelSpecifics);
  }

  /// Cancel notifications. If [id] is null, all notifications are cancelled.
  Future<void> turnOffNotifications({int id}) async {
    if (id == null) {
      await this.plugin.cancelAll();
      this.usedIds.clear();
      enabled = false;
      await StorageManager.saveData(storageKey, false);
    } else {
      this.plugin.cancel(id);
      this.usedIds.remove(id);
    }
    notifyListeners();
  }

  /// Adds an entry in [usedIds] map variable.
  /// Throws an exception if [id] is already used.
  void addToUsedId(int id, String title) {
    if (!enabled) {
      throw new Exception("Notifications not enabled");
    }
    if (this.usedIds.containsKey(id)) {
      throw Exception("Notification id already used");
    }
    this.usedIds.addAll({id: title});
    notifyListeners();
  }

  Future<void> enableService() async {
    await StorageManager.saveData(storageKey, true);
    enabled = true;
    await _initPlugin();
    notifyListeners();
  }

  Future<void> disableService() async {
    await StorageManager.saveData(storageKey, false);
    enabled = false;
    this.plugin = null;
    this.usedIds.clear();
    notifyListeners();
  }

  bool isEnabled() {
    return enabled;
  }
}
