import 'package:flutter/material.dart';

import '/design/app_button.dart';
import '/design/app_spacing.dart';
import '/design/app_typography.dart';
import '../home/home_screen.dart';
import '../onboarding/onboarding_preferences.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              Text('Everything you own.', style: AppTypography.title),

              const SizedBox(height: AppSpacing.md),

              Text(
                'Store receipts, warranties, manuals, insurance and more in one secure place.',
                style: AppTypography.bodySecondary,
              ),

              const Spacer(),

              AppButton(
                label: 'Get Started',
                onPressed: () async {
                  await OnboardingPreferences.setCompleted();

                  if (!context.mounted) return;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
