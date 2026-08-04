import 'package:flutter/material.dart';

import '/design/app_colors.dart';
import '/design/app_typography.dart';
import '/features/splash/splash_screen.dart';

void main() {
  runApp(const NowArkivedApp());
}

class NowArkivedApp extends StatelessWidget {
  const NowArkivedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NowArkived',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
        ),
        textTheme: TextTheme(
          displayLarge: AppTypography.title,
          headlineMedium: AppTypography.heading,
          bodyLarge: AppTypography.body,
          bodyMedium: AppTypography.body,
          bodySmall: AppTypography.bodySecondary,
          labelLarge: AppTypography.button,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}