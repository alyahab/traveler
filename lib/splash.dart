import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:traveler/screen/onboarding_screen.dart';
import 'package:traveler/screen/login_screen.dart';
import 'package:traveler/screen/home_screen_active.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showOnboarding = false;
  String _email = '';

  Future<void> checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstOpen = prefs.getBool('isFirstOpen') ?? true;
    setState(() {
      _showOnboarding = isFirstOpen;
    });
  }

  Future<void> completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstOpen', false);
    setState(() {
      _showOnboarding = false;
    });
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    setState(() {
      _email = email ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    checkOnboardingStatus();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(milliseconds: 100),
      splashIconSize: 200,
      splash: Image.asset('images/logo.png'),
      duration: 3000,
      nextScreen: _showOnboarding
          ? OnboardingPage(onboardingCompleteCallback: completeOnboarding)
          : _email.isEmpty
              ? LoginPage()
              : HomeController(),
    );
  }
}
