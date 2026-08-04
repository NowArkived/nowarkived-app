import 'package:flutter/material.dart';

import '/design/app_button.dart';
import '/design/app_card.dart';
import '/design/app_spacing.dart';
import '/design/app_typography.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),

              Text(
                'Everything you own.',
                style: AppTypography.title,
              ),

              const SizedBox(height: AppSpacing.sm),

              Text(
                'Organized.',
                style: AppTypography.heading,
              ),

              const SizedBox(height: AppSpacing.xxl),

              const AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MacBook Pro',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Warranty expires in 214 days',
                    ),
                  ],
                ),
              ),

              const Spacer(),

              AppButton(
                label: 'Add your first asset',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}