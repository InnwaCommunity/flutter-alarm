import 'dart:convert';
// ignore: implementation_imports
import 'package:flutter_remind/config/route.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remind/models/remind_model.dart';
import 'package:flutter_remind/screens/remaind_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Remind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: MyHomePage.route,
      onGenerateRoute: Routes.routeGenerator,
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const route = '/';
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AlarmModel> alarmList = [];

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
        title: Icon(Icons.alarm,
        color: Theme.of(context).colorScheme.secondaryContainer,),
      centerTitle: true,),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      // backgroundColor: Theme.of(context).colorScheme.primary,
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
                          return ReminderItem(
                            label: alarmList[index].remindLabal!,
                            name: dailyCheck(alarmList[index])
                                ? 'daily'
                                : '${alarmList[index].monday! ? 'Mon ' : ''}${alarmList[index].tuesday! ? ' Tue ' : ''}${alarmList[index].wednesday! ? ' Wed ' : ''}${alarmList[index].thursday! ? ' Thu ' : ''}${alarmList[index].friday! ? ' Fri ' : ''}${alarmList[index].saturday! ? ' Sat ' : ''}${alarmList[index].sunday! ? ' Sun' : ''}',
                            time: alarmList[index].notifytime!,
                            onTap: () {
                              Navigator.pushNamed(context, ReminderFormPage.route,
                                      arguments: RemainderParameter(
                                          isNew: false,
                                          alarmModel: alarmList[index]))
                                  .then((value) async {
                                if (value != null) {
                                  alarmList.removeAt(index);
                                  alarmList.add(value as AlarmModel);
                                  List<Map<String, dynamic>> jsonList = alarmList
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
                                  });
                                }
                              });
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) {
                              //       return UpdateReminderFormPage(
                              //         id: index,
                              //         alarmModel:
                              //             alarmList[index],
                              //       );
                              //     },
                              //   ),
                              // ).then((value) {
                              // removeAlarmKey();
                              // context
                              //     .read<GetAlarmBloc>()
                              //     .add(
                              //         GetAlarmListCallEvent(
                              //             pageSize: 30));
                              // });
                            },
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
        onPressed: () {
          Navigator.pushNamed(context, ReminderFormPage.route,
                  arguments: RemainderParameter(isNew: true, alarmModel: null))
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
              });
            }
          });
        },
        child: const Icon(Icons.alarm),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ReminderItem extends StatelessWidget {
  final String time;
  final String name;
  final String label;
  final VoidCallback onTap;
  const ReminderItem(
      {required this.time, required this.name, required this.onTap,required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              time.split(' ')[0],
              style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Roboto',
                  color: Theme.of(context).colorScheme.secondaryContainer),
            ),
            Text(
              time.split(' ')[1],
              textAlign: TextAlign.end,
              style: TextStyle(
                
                  fontSize: 10,
                  fontFamily: 'Roboto',
                  color: Theme.of(context).colorScheme.secondaryContainer),
            ),
            const SizedBox(width: 10,),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'Roboto',
                  color: Color(0xFF8B8B8B)),
            ),
          ],
        ),
        subtitle: Text(
          name.startsWith(',')
              ? name.replaceFirst(RegExp('[^A-Za-z]'), '')
              : name,
          style: TextStyle(
              fontSize: 17,
              fontFamily: 'Roboto-Regular',
              color: Theme.of(context).colorScheme.secondaryContainer),
        ),
      ),
    );
  }
}

String convertTimeStringToTimeOfDay(String timeString) {
  // Split the timeString into hours, minutes, and AM/PM parts
  List<String> timeParts = timeString.split(' ');
  List<String> time = timeParts[0].split(':');

  bool isPM = false;

  // Extract the hours and minutes
  int hour = int.parse(time[0]);
  int minute = int.parse(time[1]);

  // Checks whether the time is 24 hours format or not
  if (timeParts.length > 1) {
    // Determine AM/PM
    isPM = timeParts[1].toUpperCase() == 'PM';

    // Convert to 24-hour format if it's PM
    if (isPM && hour != 12) {
      hour += 12;
    }
  }

  TimeOfDay timeOfDay = TimeOfDay(hour: hour, minute: minute);
  return convertTimeOfDayToString(timeOfDay);
}

String convertTimeOfDayToString(TimeOfDay tod) {
  final DateTime now = DateTime.now();
  final dt = DateTime(
    now.year,
    now.month,
    now.day,
    tod.hour,
    tod.minute,
  );
  final format = DateFormat('hh:mm a');
  return format.format(dt);
}
