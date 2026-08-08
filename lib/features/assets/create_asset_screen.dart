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

  DateTime? _purchaseDate;
  DateTime? _warrantyExpiry;

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _serialNumberController.dispose();
    super.dispose();
  }

  Future<void> _selectPurchaseDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (date == null) return;

    setState(() {
      _purchaseDate = date;
    });
  }

  Future<void> _selectWarrantyExpiry() async {
    final date = await showDatePicker(
      context: context,
      initialDate:
          _warrantyExpiry ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    setState(() {
      _warrantyExpiry = date;
    });
  }

  void _saveAsset() {
    final name = _nameController.text.trim();
    final category = _categoryController.text.trim();
    final serialNumber = _serialNumberController.text.trim();

    if (name.isEmpty || category.isEmpty) {
      return;
    }

    final asset = Asset(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: category,
      serialNumber: serialNumber.isEmpty ? null : serialNumber,
      purchaseDate: _purchaseDate,
      warrantyExpiry: _warrantyExpiry,
      createdAt: DateTime.now(),
    );

    Navigator.pop(context, asset);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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
              'Capture the important details now. You can add documents later.',
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
              decoration: const InputDecoration(
                labelText: 'Serial number',
                hintText: 'Optional',
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            _DateField(
              label: 'Purchase date',
              value: _purchaseDate == null
                  ? 'Add purchase date'
                  : _formatDate(_purchaseDate!),
              onTap: _selectPurchaseDate,
            ),

            const SizedBox(height: AppSpacing.md),

            _DateField(
              label: 'Warranty expiry',
              value: _warrantyExpiry == null
                  ? 'Add warranty expiry'
                  : _formatDate(_warrantyExpiry!),
              onTap: _selectWarrantyExpiry,
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

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.bodySecondary,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    value,
                    style: AppTypography.body,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}