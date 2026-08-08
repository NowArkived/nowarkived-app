import 'package:flutter/material.dart';

import '../../design/app_button.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import 'models/asset.dart';

class CreateAssetScreen extends StatefulWidget {
  const CreateAssetScreen({super.key});

  @override
  State<CreateAssetScreen> createState() => _CreateAssetScreenState();
}

class _CreateAssetScreenState extends State<CreateAssetScreen> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _saveAsset() {
    final name = _nameController.text.trim();
    final category = _categoryController.text.trim();

    if (name.isEmpty || category.isEmpty) {
      return;
    }

    final asset = Asset(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: category,
      createdAt: DateTime.now(),
    );

    Navigator.pop(context, asset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Add asset',
          style: AppTypography.heading,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What do you own?',
                style: AppTypography.title,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Start with the basics. You can add documents and details later.',
                style: AppTypography.bodySecondary,
              ),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Asset name',
                  hintText: 'MacBook Pro',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _categoryController,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _saveAsset(),
                decoration: const InputDecoration(
                  labelText: 'Category',
                  hintText: 'Electronics',
                ),
              ),
              const Spacer(),
              AppButton(
                label: 'Save asset',
                onPressed: _saveAsset,
              ),
            ],
          ),
        ),
      ),
    );
  }
}