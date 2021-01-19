import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service used to push local notification for the user.
class NotificationService {
  /// Singleton instance.
  static NotificationService instance;

  /// Notification plugin used to display notifications.
  FlutterLocalNotificationsPlugin plugin;

  /// Map of used ids for notifications and his title.
  Map<int, String> usedIds = {};

  /// Initializes the singleton instance.
  static init() {
    instance = new NotificationService._();
  }

  /// Private constructor.
  NotificationService._() {
    AndroidInitializationSettings android =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    IOSInitializationSettings iOS = IOSInitializationSettings();
    InitializationSettings initializationSettings =
        InitializationSettings(android: android, iOS: iOS);
    this.plugin = FlutterLocalNotificationsPlugin();
    this
        .plugin
        .initialize(initializationSettings); // OnSelectNotification available
  }

  /// Pushes a single notification.
  Future pushNotification(String title, String body) async {
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
  Future scheduledNotification(String androidId, int id, String title,
      String body, DateTime scheduleDateTime) async {
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
  Future scheduleNotificationPeriodically(String androidId, int id,
      String title, String body, RepeatInterval interval) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      androidId,
      'Reminder notifications',
      'Remember about it',
      icon: 'smile_icon',
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
  Future turnOffNotification({int id}) async {
    if (id == null) {
      this.plugin.cancelAll();
      this.usedIds.clear();
    } else {
      this.plugin.cancel(id);
      this.usedIds.remove(id);
    }
  }

  /// Adds an entry in [usedIds] map variable.
  /// Throws an exception if [id] is already used.
  void addToUsedId(int id, String title) {
    if (this.usedIds.containsKey(id)) {
      throw Exception("Notification id already used");
    }
    this.usedIds.addAll({id: title});
  }
}
