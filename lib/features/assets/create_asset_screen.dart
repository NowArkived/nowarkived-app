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
  final _serialNumberController = TextEditingController();
  final _purchaseDateController = TextEditingController();
  final _warrantyExpiryController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _serialNumberController.dispose();
    _purchaseDateController.dispose();
    _warrantyExpiryController.dispose();
    super.dispose();
  }

  String? _optionalValue(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
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
      serialNumber: _optionalValue(_serialNumberController),
      purchaseDate: _optionalValue(_purchaseDateController),
      warrantyExpiry: _optionalValue(_warrantyExpiryController),
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
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'What do you own?',
              style: AppTypography.title,
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              'Capture the important details now. Documents can be added later.',
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
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Category',
                hintText: 'Electronics',
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            TextField(
              controller: _serialNumberController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Serial number',
                hintText: 'Optional',
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            TextField(
              controller: _purchaseDateController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Purchase date',
                hintText: 'e.g. 08/08/2026',
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            TextField(
              controller: _warrantyExpiryController,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _saveAsset(),
              decoration: const InputDecoration(
                labelText: 'Warranty expiry',
                hintText: 'e.g. 08/08/2027',
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            AppButton(
              label: 'Save asset',
              onPressed: _saveAsset,
            ),
          ],
        ),
      ),
    );
  }
}