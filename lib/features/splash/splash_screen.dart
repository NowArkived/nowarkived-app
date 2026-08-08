import 'dart:async';

import 'package:flutter/material.dart';

import '../../design/app_colors.dart';
import '../../design/app_typography.dart';
import '../home/home_screen.dart';
import '../onboarding/onboarding_preferences.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 @override
void initState() {
  super.initState();

  Timer(const Duration(seconds: 2), () async {
    if (!mounted) return;

    final completed = await OnboardingPreferences.isCompleted();

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            completed ? const HomeScreen() : const OnboardingScreen(),
      ),
    );
  });
}
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'NowArkived',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}