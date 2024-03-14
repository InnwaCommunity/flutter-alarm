import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_remind/models/remind_model.dart';
// ignore: implementation_imports
import 'package:intl/src/intl/date_format.dart';

class DaySign {
  final bool value;
  final String name;
  final Function(bool?) onPress;
  DaySign({required this.value, required this.name, required this.onPress});
}

class RemainderParameter {
  final bool isNew;
  final AlarmModel? alarmModel;
  RemainderParameter({
    required this.isNew,
    required this.alarmModel,
  });
}

class ReminderFormPage extends StatefulWidget {
  static const route = '/editRemind';
  final RemainderParameter remainderParameter;
  const ReminderFormPage({
    required this.remainderParameter,
    super.key,
  });

  @override
  State<ReminderFormPage> createState() => _ReminderFormPageState();
}

class _ReminderFormPageState extends State<ReminderFormPage> {
  bool custom = true;

  TimeOfDay notifytime = TimeOfDay.now();
  final TextEditingController editingController = TextEditingController();

  int isMute = 0;
  int alarmtype = 0;
  bool ison = true;

  bool daily = true;
  bool monday = true;
  bool tuesday = true;
  bool wednesday = true;
  bool thursday = true;
  bool friday = true;
  bool saturday = true;
  bool sunday = true;
  DateTime? customOnce;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: notifytime,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              textTheme: null,
              colorScheme: ColorScheme.light(
                  surface: const Color(0xFF8B8B8B),
                  tertiaryContainer:
                      Colors.blue[50],
                  primaryContainer:
                      Colors.blue[50], 
                  onPrimaryContainer:
                      const Color(0xFF063AB5)
                  ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context)
                      .colorScheme
                      .secondaryContainer,
                ),
              ),
            ),
            child: Localizations.override(
              context: context,
              locale: const Locale('en', 'US'),
              child: child,
            ),
          );
        });
    if (picked != null) {
      setState(() {
        notifytime = picked;
      });
    }
  }

  bool isDaily() {
    customOnce=null;
    if (monday &&
        tuesday &&
        wednesday &&
        thursday &&
        friday &&
        saturday &&
        sunday) {
      return true;
    } else {
      return false;
    }
  }

  List<DaySign> days = [];

  @override
  void initState() {
    if (!widget.remainderParameter.isNew &&
        widget.remainderParameter.alarmModel != null) {
      monday = widget.remainderParameter.alarmModel!.monday!;
      thursday = widget.remainderParameter.alarmModel!.thursday!;
      wednesday = widget.remainderParameter.alarmModel!.wednesday!;
      tuesday = widget.remainderParameter.alarmModel!.tuesday!;
      friday = widget.remainderParameter.alarmModel!.friday!;
      saturday = widget.remainderParameter.alarmModel!.saturday!;
      sunday = widget.remainderParameter.alarmModel!.sunday!;
      String hm =
          widget.remainderParameter.alarmModel!.notifytime!.split(' ')[0];
      notifytime = TimeOfDay(
          hour: int.parse(hm.split(':')[0]),
          minute: int.parse(hm.split(':')[1]));
      editingController.text =
          widget.remainderParameter.alarmModel!.remindLabal!;
      daily = isDaily();
    }
    super.initState();
  }

  Future<void> checkRemindList() async {}

  int generateUniqueId() {
    Random random = Random();
    return random.nextInt(1000000);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
          ),
          title: Text(
            'Remind',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop(AlarmModel(
                    notifytime: changeNotime(),
                    monday: monday,
                    tuesday: tuesday,
                    wednesday: wednesday,
                    thursday: thursday,
                    friday: friday,
                    saturday: saturday,
                    sunday: sunday,
                    alarmid: widget.remainderParameter.isNew
                        ? generateUniqueId()
                        : widget.remainderParameter.alarmModel!.alarmid,
                    remindLabal: editingController.text,
                    customOnce: customOnce));
              },
              child: SizedBox(
                height: 32,
                width: 32,
                child: Icon(
                  Icons.done,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
          ],
          shadowColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatTimeOfDay(notifytime),
                        style: TextStyle(
                            fontSize: 50,
                            fontFamily: 'Roboto',
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer),
                      ),
                      Text(
                        notifytime.hour >= 12 ? 'PM' : 'AM',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  showCustomBottomSheet(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Days',
                      style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.secondaryContainer),
                    ),
                    Text(
                      '${getDays()}>',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Roboto',
                          color:
                              Theme.of(context).colorScheme.secondaryContainer),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          title: Text(
                            'Edit Alarm Label',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer),
                          ),
                          content: TextField(
                            controller: editingController,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  editingController.clear();
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer),
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer),
                                ))
                          ],
                        );
                      });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Label',
                      style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.secondaryContainer),
                    ),
                    Text(
                      editingController.text.isNotEmpty ? '${editingController.text} >' : ' - >',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Roboto',
                          color:
                              Theme.of(context).colorScheme.secondaryContainer),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  String getDays() {
    String ds = '';
    if (customOnce != null) {
      return ' Once ';
    }
    if (daily) {
      ds += 'Daily';
    } else {
      if (monday) {
        ds += ' Mon ';
      }
      if (tuesday) {
        ds += ' Tue ';
      }
      if (wednesday) {
        ds += ' Wed ';
      }
      if (thursday) {
        ds += ' Thu ';
      }
      if (friday) {
        ds += ' Fri ';
      }
      if (saturday) {
        ds += ' Sat ';
      }
      if (sunday) {
        ds += ' Sun ';
      }
    }

    return ds;
  }

  String changeNotime() {
    String hour = notifytime.hour < 10
        ? '0${notifytime.hour}'
        : notifytime.hour.toString();
    String timstat = notifytime.hour >= 12 ? 'PM' : 'AM';
    String minute = notifytime.minute < 10
        ? '0${notifytime.minute}'
        : notifytime.minute.toString();
    return '$hour:$minute $timstat';
  }

  void showCustomBottomSheet(BuildContext buildcontext) {
    showModalBottomSheet<void>(
      context: context,
      elevation: 0,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            height: 800,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 20,
                left: 20,
                top: 10,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ReverseRowCheckBoxButton(
                      value: daily,
                      name: 'Daily',
                      onPress: (vlue) {
                        mystate(() {
                          customOnce=null;
                          alarmtype = 0;
                          daily = vlue!;
                          monday = vlue;
                          tuesday = vlue;
                          wednesday = vlue;
                          thursday = vlue;
                          friday = vlue;
                          saturday = vlue;
                          sunday = vlue;
                        });
                      },
                    ),
                    ReverseRowCheckBoxButton(
                      value: monday,
                      name: 'Monday',
                      onPress: (vlue) {
                        mystate(() {
                          monday = vlue!;
                          daily = isDaily();
                          alarmtype = 3;
                        });
                      },
                    ),
                    ReverseRowCheckBoxButton(
                      value: tuesday,
                      name: 'Tuesday',
                      onPress: (vlue) {
                        mystate(() {
                          tuesday = vlue!;
                          daily = isDaily();
                          alarmtype = 3;
                        });
                      },
                    ),
                    ReverseRowCheckBoxButton(
                      value: wednesday,
                      name: 'Wednesday',
                      onPress: (vlue) {
                        mystate(() {
                          wednesday = vlue!;
                          daily = isDaily();
                          alarmtype = 3;
                        });
                      },
                    ),
                    ReverseRowCheckBoxButton(
                      value: thursday,
                      name: 'Thursday',
                      onPress: (vlue) {
                        mystate(() {
                          thursday = vlue!;
                          daily = isDaily();
                          alarmtype = 3;
                        });
                      },
                    ),
                    ReverseRowCheckBoxButton(
                      value: friday,
                      name: 'Friday',
                      onPress: (vlue) {
                        mystate(() {
                          friday = vlue!;
                          daily = isDaily();
                          alarmtype = 3;
                        });
                      },
                    ),
                    ReverseRowCheckBoxButton(
                      value: saturday,
                      name: 'Saturday',
                      onPress: (vlue) {
                        mystate(() {
                          saturday = vlue!;
                          daily = isDaily();
                          alarmtype = 3;
                        });
                      },
                    ),
                    ReverseRowCheckBoxButton(
                      value: sunday,
                      name: 'Sunday',
                      onPress: (vlue) {
                        mystate(
                          () {
                            sunday = vlue!;
                            daily = isDaily();
                            alarmtype = 3;
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              initialDatePickerMode: DatePickerMode.day,
                              firstDate: DateTime(2015),
                              lastDate: DateTime(2101),
                              helpText: 'SELECT DATE',
                              cancelText: 'CANCEL',
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    textTheme: null,
                                    colorScheme: ColorScheme.light(
                                      surface: const Color(
                                              0xFF8B8B8B),
                                          tertiaryContainer: Colors.blue[
                                              50],
                                          primaryContainer: Colors.blue[
                                              50],
                                          onPrimaryContainer: const Color(
                                              0xFF063AB5)
                                    ),
                                    inputDecorationTheme: InputDecorationTheme(
                                        border: const UnderlineInputBorder(),
                                        labelStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondaryContainer)),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                      ),
                                    ),
                                  ),
                                  child: Localizations.override(
                                    context: context,
                                    locale: const Locale('en', 'US'),
                                    child: child,
                                  ),
                                );
                              });
                          if (picked != null && mounted) {
                            final TimeOfDay? timepicked = await showTimePicker(
                                context: context,
                                initialTime: notifytime,
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      textTheme: null,
                                      colorScheme: ColorScheme.light(
                                          surface: const Color(
                                              0xFF8B8B8B), 
                                          tertiaryContainer: Colors.blue[
                                              50], 
                                          primaryContainer: Colors.blue[
                                              50], 
                                          onPrimaryContainer: const Color(
                                              0xFF063AB5) 
                                          ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer, 
                                        ),
                                      ),
                                    ),
                                    child: Localizations.override(
                                      context: context,
                                      locale: const Locale('en', 'US'),
                                      child: child,
                                    ),
                                  );
                                });
                            if (timepicked != null) {
                              mystate(() {
                                daily = false;
                                monday = false;
                                tuesday = false;
                                wednesday = false;
                                thursday = false;
                                friday = false;
                                saturday = false;
                                sunday = false;
                                customOnce = DateTime(
                                    picked.year,
                                    picked.month,
                                    picked.day,
                                    timepicked.hour,
                                    timepicked.minute);
                                customOnce!.weekday == 1
                                    ? monday = true
                                    : customOnce!.weekday == 2
                                        ? tuesday = true
                                        : customOnce!.weekday == 3
                                            ? wednesday = true
                                            : customOnce!.weekday == 4
                                                ? thursday = true
                                                : customOnce!.weekday == 5
                                                    ? friday = true
                                                    : customOnce!.weekday == 6
                                                        ? saturday = true
                                                        : sunday;
                                  notifytime = TimeOfDay(
                                    hour: customOnce!.hour,
                                    minute: customOnce!.minute);
                                
                              });
                            }
                          }
                        },
                        child: Text( customOnce != null ? '${customOnce.toString()} >' : 'Custom Once >',style: TextStyle(
              fontSize: 17,
              fontFamily: 'Roboto',
              color: Theme.of(context).colorScheme.secondaryContainer),))
                  ],
                ),
              ),
            ),
          );
        });
      },
    ).then((value) => setState(() {}));
  }
  String formatTimeOfDay(TimeOfDay tod) {
    final DateTime now = DateTime.now();
    final dt = DateTime(
      now.year,
      now.month,
      now.day,
      tod.hour,
      tod.minute,
    );
    final format = DateFormat('hh:mm');
    return format.format(dt);
  }
}

class ReverseRowCheckBoxButton extends StatelessWidget {
  final bool value;
  final Function(bool? value)? onPress;
  final String name;
  const ReverseRowCheckBoxButton({
    required this.value,
    required this.name,
    super.key,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(
              fontSize: 17,
              fontFamily: 'Roboto',
              color: Theme.of(context).colorScheme.secondaryContainer),
        ),
        Checkbox(
          activeColor: const Color(0xFF3d83ff),
          value: value,
          onChanged: onPress,
        ),
      ],
    );
  }
}
