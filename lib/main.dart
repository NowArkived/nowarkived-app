import 'package:flutter/material.dart';

import '/design/app_colors.dart';
import '/design/app_typography.dart';
import '/design/app_button.dart';
import '/design/app_spacing.dart';
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          surface: AppColors.background,
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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
  padding: const EdgeInsets.all(AppSpacing.lg),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Everything you own.',
        style: Theme.of(context).textTheme.displayLarge,
      ),
      const SizedBox(height: AppSpacing.sm),
      Text(
        'Organized.',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: AppSpacing.xl),
      AppButton(
        label: 'Add your first asset',
        onPressed: () {},
      ),
    ],
  ),
),
    );
  }
}