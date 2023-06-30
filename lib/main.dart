import 'package:flutter/material.dart';
import 'package:traveler/screen/forgotpassword_screen.dart';
import 'package:traveler/screen/login_screen.dart';
import 'package:traveler/screen/home_screen_active.dart';
import 'package:traveler/screen/pages/all1_screen.dart';
import 'package:traveler/screen/pages/all2_screen.dart';
import 'package:traveler/screen/pages/detail_screen.dart';
import 'package:traveler/screen/register_screen.dart';
import 'package:traveler/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TRAVELER',
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginPage(),
        '/register': (BuildContext context) => RegisterPage(),
        '/forgot': (BuildContext context) => ForgotPasswordPage(),
        '/home': (BuildContext context) => HomeController(),
        '/detail': (BuildContext context) => DetailPage(),
        '/all_1': (BuildContext context) => AllPage1(),
        '/all_2': (BuildContext context) => AllPage2()
      },
    );
  }
}
