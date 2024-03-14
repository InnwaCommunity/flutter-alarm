
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_remind/controllers/alarm_settings.dart';
import 'package:flutter_remind/models/remind_model.dart';
import 'package:flutter_remind/screens/remaind_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MyHomePage extends StatefulWidget {
  static const route = '/';
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AlarmModel> alarmList = [];
  List<int> selectedIndex=[];
  
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    getAlarmList();
  }

  Future<void> getAlarmList() async {
    final pref = await SharedPreferences.getInstance();
    String? val = pref.getString('RemindKey');
    if (val != null && val.isNotEmpty) {
      var valData = jsonDecode(val);
      alarmList = (valData as List).map((e) => AlarmModel.fromJson(e)).toList();
      setState(() {});
    }
  }

  bool dailyCheck(AlarmModel model) {
    if (model.monday == true &&
        model.tuesday == true &&
        model.wednesday == true &&
        model.thursday == true &&
        model.friday == true &&
        model.saturday == true &&
        model.sunday == true) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Icon(
          Icons.alarm,
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Center(
          child: alarmList.isEmpty
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'There is No Reminder List',
                    ),
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Opacity(
                            opacity: alarmList[index].customOnce != null &&
                                    alarmList[index]
                                        .customOnce!
                                        .isBefore(DateTime.now())
                                ? 0.3
                                : 1.0,
                            child: InkWell(
                              onLongPress: () {
                                selectedIndex.add(index);
                                setState(() {});
                              },
                              onTap: () {
                                if (selectedIndex.isNotEmpty) {
                                  if (selectedIndex.contains(index)) {
                                    selectedIndex.remove(index);
                                  } else {
                                    selectedIndex.add(index);
                                  }
                                  setState(() {});
                                  return;
                                }
                                Navigator.pushNamed(
                                        context, ReminderFormPage.route,
                                        arguments: RemainderParameter(
                                            isNew: false,
                                            alarmModel: alarmList[index]))
                                    .then((value) async {
                                  if (value != null) {
                                    alarmList.removeAt(index);
                                    alarmList.add(value as AlarmModel);
                                    List<Map<String, dynamic>> jsonList =
                                        alarmList
                                            .map((alarm) => alarm.toJson())
                                            .toList();
                                    String jsonString = jsonEncode(jsonList);
                                    final pref =
                                        await SharedPreferences.getInstance();
                                    pref.clear();
                                    pref
                                        .setString('RemindKey', jsonString)
                                        .then((value) {
                                      String? val = pref.getString('RemindKey');
                                      if (val != null && val.isNotEmpty) {
                                        var valData = jsonDecode(val);
                                        alarmList = (valData as List)
                                            .map((e) => AlarmModel.fromJson(e))
                                            .toList();
                                      }
                                      setState(() {});
                                      setAlarm();
                                    });
                                  }
                                });
                              },
                              child: ListTile(
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      alarmList[index]
                                          .notifytime!
                                          .split(' ')[0],
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: 'Roboto',
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer),
                                    ),
                                    Text(
                                      alarmList[index]
                                          .notifytime!
                                          .split(' ')[1],
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'Roboto',
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      alarmList[index].remindLabal!,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Roboto',
                                          color: Color(0xFF8B8B8B)),
                                    ),
                                  ],
                                ),
                                subtitle: subtitle(alarmList[index]
                                            .customOnce !=
                                        null
                                    ? alarmList[index].customOnce.toString()
                                    : dailyCheck(alarmList[index])
                                        ? 'daily'
                                        : '${alarmList[index].monday! ? 'Mon ' : ''}${alarmList[index].tuesday! ? ' Tue ' : ''}${alarmList[index].wednesday! ? ' Wed ' : ''}${alarmList[index].thursday! ? ' Thu ' : ''}${alarmList[index].friday! ? ' Fri ' : ''}${alarmList[index].saturday! ? ' Sat ' : ''}${alarmList[index].sunday! ? ' Sun' : ''}'),
                                trailing: Visibility(
                                    visible: selectedIndex.isNotEmpty,
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          color: selectedIndex.contains(index)
                                              ? Colors.blue
                                              : null,
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    )),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: const Color(0xFF8B8B8B).withOpacity(0.3),
                          );
                        },
                        itemCount: alarmList.length,
                      ),
                    ),
                  ],
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selectedIndex.isEmpty) {
            Navigator.pushNamed(context, ReminderFormPage.route,
                    arguments:
                        RemainderParameter(isNew: true, alarmModel: null))
                .then((value) async {
              if (value != null) {
                alarmList.add(value as AlarmModel);
                List<Map<String, dynamic>> jsonList =
                    alarmList.map((alarm) => alarm.toJson()).toList();
                String jsonString = jsonEncode(jsonList);
                final pref = await SharedPreferences.getInstance();
                pref.clear();
                pref.setString('RemindKey', jsonString).then((value) {
                  String? val = pref.getString('RemindKey');
                  if (val != null && val.isNotEmpty) {
                    var valData = jsonDecode(val);
                    alarmList = (valData as List)
                        .map((e) => AlarmModel.fromJson(e))
                        .toList();
                  }
                  setState(() {});
                  setAlarm();
                });
              }
            });
          } else {
            for (var i = 0; i < selectedIndex.length; i++) {
              alarmList.removeAt(selectedIndex[i]);
            }
            selectedIndex = [];
            List<Map<String, dynamic>> jsonList =
                alarmList.map((alarm) => alarm.toJson()).toList();
            String jsonString = jsonEncode(jsonList);
            final pref = await SharedPreferences.getInstance();
            pref.clear();
            pref.setString('RemindKey', jsonString).then((value) {
              String? val = pref.getString('RemindKey');
              if (val != null && val.isNotEmpty) {
                var valData = jsonDecode(val);
                alarmList = (valData as List)
                    .map((e) => AlarmModel.fromJson(e))
                    .toList();
              }
              setState(() {});
              setAlarm();
            });
          }
        },
        child: Icon(selectedIndex.isEmpty ? Icons.alarm : Icons.delete),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  Widget subtitle(String name){
    return Text(
          name.startsWith(',')
              ? name.replaceFirst(RegExp('[^A-Za-z]'), '')
              : name,
          style: TextStyle(
              fontSize: 17,
              fontFamily: 'Roboto-Regular',
              color: Theme.of(context).colorScheme.secondaryContainer),
        );
  }
  Future<void> setAlarm() async {
    _flutterLocalNotificationsPlugin.cancelAll();
    for (var i = 0; i < alarmList.length; i++) {
      await AlarmSettings.showzonedScheduleNotification(
          flnp: _flutterLocalNotificationsPlugin, alarmModel: alarmList[i]);
    }
  }
}
