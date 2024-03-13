

import 'package:flutter/material.dart';
import 'package:flutter_remind/main.dart';
import 'package:flutter_remind/screens/remaind_edit.dart';

class Routes{
  static Route<dynamic>? routeGenerator(RouteSettings settings){
    final argument =settings.arguments;
    switch (settings.name) {
      case MyHomePage.route:
        return makeRoute(const MyHomePage(), settings);
      case ReminderFormPage.route:
      return makeRoute(ReminderFormPage(remainderParameter: argument as RemainderParameter), settings);
      default:
    }
    return null;
  }
}


Route? makeRoute(Widget widget, RouteSettings settings) {
  return MaterialPageRoute(
    builder: (context) {
      return widget;
    },
    settings: settings,
  );
}