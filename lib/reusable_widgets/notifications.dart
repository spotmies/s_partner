import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class LocalNotidication {
  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String>();
  static final sound = 'notification_sound.wav';

  static Future notificationDetails({String bigImage, String largeIcon,bool show = false}) async {
    final styleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigImage),
        largeIcon: FilePathAndroidBitmap(largeIcon));

    return NotificationDetails(
        android: AndroidNotificationDetails(
            'channel id 1', 'channel name', 'channel Description',
            sound: RawResourceAndroidNotificationSound(sound.split('.').first),
            styleInformation: show? styleInformation:null, importance: Importance.max),
        iOS: IOSNotificationDetails());
  }

  static Future init({bool initSchedule = false}) async {
    final android = AndroidInitializationSettings('launch_background');
    final ios = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: ios);

    // when app is closed
    final details = await notifications.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp){
      onNotifications.add(details.payload);
    }

    await notifications.initialize(settings,
        onSelectNotification: (payload) async {
      onNotifications.add(payload);
    });

    if (initSchedule) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future showNotifications(
      {int id = 0,
      String title,
      String body,
      String payload,
      String bigImage,
      String largeIcon}) async {
    notifications.show(id, title, body,
        await notificationDetails(bigImage: bigImage, largeIcon: largeIcon,show: true),
        payload: payload);
  }

  static Future showShedduleNotifications(
      {int id = 0,
      String title,
      String body,
      String payload,
      @required DateTime scheduledDate}) async {
    notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      // scheduleDaily(Time(10,30,00)),
      await notificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);

    return scheduleDate.isBefore(now)
        ? scheduleDate.add(Duration(seconds: 1))
        : scheduleDate;
  }
}