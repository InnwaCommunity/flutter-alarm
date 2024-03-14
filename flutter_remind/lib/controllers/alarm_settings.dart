import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_remind/models/remind_model.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

class AlarmSettings {
  static Future notiInital() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings androidinit =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings iosInit = const DarwinInitializationSettings();
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidinit, iOS: iosInit);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future showzonedScheduleNotification(
      {required FlutterLocalNotificationsPlugin flnp,
      required AlarmModel alarmModel,
      bool? isMute}) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
            'innwa_community_alarm_channel_id', 'Alarm',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            visibility: NotificationVisibility.public,
            audioAttributesUsage: AudioAttributesUsage.alarm,
            sound:
                RawResourceAndroidNotificationSound('games_of_thrones_10207'));

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(sound: 'games_of_thrones_10207.wav');

    NotificationDetails node = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    if (alarmModel.customOnce != null) {
      tz.TZDateTime tzDateTime =
          tz.TZDateTime.from(alarmModel.customOnce!, tz.local);
      int id = alarmModel.alarmid!;
      if (isMute == null ||
          (isMute && DateTime.now().weekday != DateTime.monday)) {
        await _alarmSchedule(
            flnp, id, alarmModel.remindLabal!, tzDateTime, node,
            oNce: true);
      }
    } else {
    if (alarmModel.monday!) {
      tz.TZDateTime tzDateTime = _getScheduleDT(
          time: alarmModel.notifytime!.split(' ')[0], date: DateTime.monday);
      int id = int.parse('${alarmModel.alarmid}${DateTime.monday}');
      if (isMute == null ||
          (isMute && DateTime.now().weekday != DateTime.monday)) {
        await _alarmSchedule(
            flnp, id, alarmModel.remindLabal!, tzDateTime, node,oNce: false);
      }
    }
    if (alarmModel.tuesday!) {
      tz.TZDateTime tzDateTime = _getScheduleDT(
          time: alarmModel.notifytime!.split(' ')[0], date: DateTime.tuesday);
      int id = int.parse('${alarmModel.alarmid}${DateTime.tuesday}');
      if (isMute == null ||
          (isMute && DateTime.now().weekday != DateTime.tuesday)) {
        await _alarmSchedule(
            flnp, id, alarmModel.remindLabal!, tzDateTime, node);
      }
    }
    if (alarmModel.wednesday!) {
      tz.TZDateTime tzDateTime = _getScheduleDT(
          time: alarmModel.notifytime!.split(' ')[0], date: DateTime.wednesday);
      int id = int.parse('${alarmModel.alarmid}${DateTime.wednesday}');
      if (isMute == null ||
          (isMute && DateTime.now().weekday != DateTime.wednesday)) {
        await _alarmSchedule(
            flnp, id, alarmModel.remindLabal!, tzDateTime, node);
      }
    }
    if (alarmModel.thursday!) {
      tz.TZDateTime tzDateTime = _getScheduleDT(
          time: alarmModel.notifytime!.split(' ')[0], date: DateTime.thursday);
      int id = int.parse('${alarmModel.alarmid}${DateTime.thursday}');
      if (isMute == null ||
          (isMute && DateTime.now().weekday != DateTime.thursday)) {
        await _alarmSchedule(
            flnp, id, alarmModel.remindLabal!, tzDateTime, node);
      }
    }
    if (alarmModel.friday!) {
      tz.TZDateTime tzDateTime = _getScheduleDT(
          time: alarmModel.notifytime!.split(' ')[0], date: DateTime.friday);
      int id = int.parse('${alarmModel.alarmid}${DateTime.friday}');
      if (isMute == null ||
          (isMute && DateTime.now().weekday != DateTime.friday)) {
        await _alarmSchedule(
            flnp, id, alarmModel.remindLabal!, tzDateTime, node);
      }
    }
    if (alarmModel.saturday!) {
      tz.TZDateTime tzDateTime = _getScheduleDT(
          time: alarmModel.notifytime!.split(' ')[0], date: DateTime.saturday);
      int id = int.parse('${alarmModel.alarmid}${DateTime.saturday}');
      if (isMute == null ||
          (isMute && DateTime.now().weekday != DateTime.saturday)) {
        await _alarmSchedule(
            flnp, id, alarmModel.remindLabal!, tzDateTime, node);
      }
    }
    if (alarmModel.sunday!) {
      tz.TZDateTime tzDateTime = _getScheduleDT(
          time: alarmModel.notifytime!.split(' ')[0], date: DateTime.sunday);
      int id = int.parse('${alarmModel.alarmid}${DateTime.sunday}');
      if (isMute == null ||
          (isMute && DateTime.now().weekday != DateTime.sunday)) {
        await _alarmSchedule(
            flnp, id, alarmModel.remindLabal!, tzDateTime, node);
      }
    }
      
    }
  }

  static tz.TZDateTime _getScheduleDT(
      {required String time, required int date}) {
    DateTime now = DateTime.now();
    DateTime firstOfMonth = DateTime(now.year, now.month, 1);
    DateTime dueDate = firstOfMonth
        .add(Duration(days: (7 - (firstOfMonth.weekday - date)) % 7));

    DateTime datetime = DateTime(now.year, now.month, dueDate.day,
        int.parse(time.split(':')[0]), int.parse(time.split(':')[1]));
    return tz.TZDateTime.from(datetime, tz.local);
  }

  static Future<void> _alarmSchedule(FlutterLocalNotificationsPlugin flnp,
      int id, String label, tz.TZDateTime tzDateTime, NotificationDetails node,
      {bool? oNce}) async {
    await flnp.zonedSchedule(
      id,
      'Innwa Community Alarm',
      label,
      tzDateTime,
      node,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: oNce != null && oNce
          ? DateTimeComponents.dateAndTime
          : DateTimeComponents.dayOfWeekAndTime,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }
}
