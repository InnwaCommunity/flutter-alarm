import 'package:intl/intl.dart';
class AlarmModel {
  String? notifytime;
  String? twentyfourhour;
  bool? monday;
  bool? tuesday;
  bool? wednesday;
  bool? thursday;
  bool? friday;
  bool? saturday;
  bool? sunday;
  int? alarmid;
  int? notificationId;
  String? remindLabal;
  DateTime? customOnce;

  AlarmModel(
      {
      this.notifytime,
      this.twentyfourhour,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday,
      this.sunday,
      this.alarmid,
      this.notificationId,
      this.remindLabal,
      this.customOnce});
   AlarmModel.fromJson(Map<String, dynamic> json) {
    notifytime = json['notifytime'];
    twentyfourhour = json['notifytime'] != null
        ? convertTo24HourFormat(json['notifytime'])
        : null;
    monday = json['Monday'];
    tuesday = json['Tueday'];
    wednesday = json['Wednesday'];
    thursday = json['Thursday'];
    friday = json['Friday'];
    saturday = json['Saturday'];
    sunday = json['Sunday'];
    alarmid = json['alarmid'];
    notificationId = json['NotificationId'];
    remindLabal = json['Labal'] ?? '';
    customOnce = json['CustomOnce'] != null
        ? DateFormat("yyyy-MM-dd HH:mm:ss").parse(json['CustomOnce'])
        : json['CustomOnce'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['notifytime'] = notifytime;
    data['Monday'] = monday;
    data['Tueday'] = tuesday;
    data['Wednesday'] = wednesday;
    data['Thursday'] = thursday;
    data['Friday'] = friday;
    data['Saturday'] = saturday;
    data['Sunday'] = sunday;
    data['alarmid'] = alarmid;
    data['NotificationId'] = notificationId;
    data['Labal'] = remindLabal;
    data['CustomOnce'] = customOnce != null
        ? DateFormat("yyyy-MM-dd HH:mm:ss").format(customOnce!)
        : customOnce;
    return data;
  }
}

/// convert12HourTo24HourFormat
String? convertTo24HourFormat(String time) {
  try {
    final parts = time.split(' ');
    final timeParts = parts[0].split(':');
    int hours = int.parse(timeParts[0]);
    final minutes = int.parse(timeParts[1]);
    final isPM = parts[1].toLowerCase() == 'pm';

    if (isPM && hours < 12) {
      hours += 12;
    } else if (!isPM && hours == 12) {
      hours = 0;
    }

    final result =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    return result;
  } on Exception catch (_) {
    return null;
  }
}