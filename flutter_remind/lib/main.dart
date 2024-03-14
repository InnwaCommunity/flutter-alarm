import 'package:flutter_remind/config/route.dart';
import 'package:flutter_remind/controllers/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remind/screens/myhome_page.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest_all.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  AlarmSettings.notiInital();
  await _configureLocalTimeZone();
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
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
