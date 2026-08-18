import 'package:flutter/material.dart';

import '../../design/app_button.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import 'models/asset.dart';
import 'models/asset_category.dart';

class EditAssetScreen extends StatefulWidget {
  const EditAssetScreen({super.key, required this.asset});

  final Asset asset;

  @override
  State<EditAssetScreen> createState() => _EditAssetScreenState();
}

class _EditAssetScreenState extends State<EditAssetScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _serialNumberController;

  AssetCategory? _category;
  DateTime? _purchaseDate;
  DateTime? _warrantyExpiry;

  bool get _canSave =>
      _nameController.text.trim().isNotEmpty && _category != null;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.asset.name);
    _serialNumberController = TextEditingController(
      text: widget.asset.serialNumber ?? '',
    );

    _category = _categoryFromString(widget.asset.category);
    _purchaseDate = widget.asset.purchaseDate;
    _warrantyExpiry = widget.asset.warrantyExpiry;

    _nameController.addListener(_refresh);
  }

  @override
  void dispose() {
    _nameController.removeListener(_refresh);
    _nameController.dispose();
    _serialNumberController.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  AssetCategory _categoryFromString(String value) {
    for (final category in AssetCategory.values) {
      if (category.label.toLowerCase() == value.toLowerCase()) {
        return category;
      }
    }

    return AssetCategory.other;
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

  void _save() {
    if (!_canSave) return;

    final serial = _serialNumberController.text.trim();

    final updatedAsset = widget.asset.copyWith(
      name: _nameController.text.trim(),
      category: _category!.label,
      serialNumber: serial.isEmpty ? null : serial,
      clearSerialNumber: serial.isEmpty,
      purchaseDate: _purchaseDate,
      clearPurchaseDate: _purchaseDate == null,
      warrantyExpiry: _warrantyExpiry,
      clearWarrantyExpiry: _warrantyExpiry == null,
    );

    Navigator.pop(context, updatedAsset);
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
        title: Text('Edit asset', style: AppTypography.heading),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('Asset details', style: AppTypography.title),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Keep your ownership information accurate and up to date.',
              style: AppTypography.bodySecondary,
            ),
            const SizedBox(height: AppSpacing.xl),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Asset name'),
            ),

            const SizedBox(height: AppSpacing.md),

            DropdownButtonFormField<AssetCategory>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: AssetCategory.values
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category.label),
                    ),
                  )
                  .toList(),
              onChanged: (category) {
                setState(() {
                  _category = category;
                });
              },
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
              onClear: _purchaseDate == null
                  ? null
                  : () {
                      setState(() {
                        _purchaseDate = null;
                      });
                    },
            ),

            const SizedBox(height: AppSpacing.md),

            _DateField(
              label: 'Warranty expiry',
              value: _warrantyExpiry == null
                  ? 'Add warranty expiry'
                  : _formatDate(_warrantyExpiry!),
              onTap: _selectWarrantyExpiry,
              onClear: _warrantyExpiry == null
                  ? null
                  : () {
                      setState(() {
                        _warrantyExpiry = null;
                      });
                    },
            ),

            const SizedBox(height: AppSpacing.xl),

            AppButton(
              label: 'Save changes',
              onPressed: _canSave ? _save : null,
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
    this.onClear,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTypography.bodySecondary),
                  const SizedBox(height: AppSpacing.xs),
                  Text(value, style: AppTypography.body),
                ],
              ),
            ),
          ),
          if (onClear != null)
            IconButton(
              onPressed: onClear,
              icon: const Icon(Icons.close, color: AppColors.textSecondary),
            )
          else
            const Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: AppColors.textSecondary,
            ),
        ],
      ),
    );
  }
}
