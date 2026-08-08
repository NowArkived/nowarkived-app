import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../design/app_button.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import '../scan/receipt_scanner_screen.dart';
import 'models/asset_document.dart';

class AddDocumentScreen extends StatefulWidget {
  const AddDocumentScreen({super.key});

  @override
  State<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  String? _selectedFileName;
  AssetDocumentType _selectedType = AssetDocumentType.receipt;

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles();

    if (result == null || result.files.isEmpty) {
      return;
    }

    if (!mounted) return;

    setState(() {
      _selectedFileName = result.files.first.name;
    });
  }

  Future<void> _scanReceipt() async {
    final receipt = await Navigator.push<XFile>(
      context,
      MaterialPageRoute(builder: (_) => const ReceiptScannerScreen()),
    );

    if (receipt == null) return;

    setState(() {
      _selectedFileName = receipt.name;
      _selectedType = AssetDocumentType.receipt;
    });
  }

  void _saveDocument() {
    final fileName = _selectedFileName;

    if (fileName == null) return;

    final document = AssetDocument(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: fileName,
      type: _selectedType,
      createdAt: DateTime.now(),
    );

    Navigator.pop(context, document);
  }

  String _typeLabel(AssetDocumentType type) {
    switch (type) {
      case AssetDocumentType.receipt:
        return 'Receipt';
      case AssetDocumentType.warranty:
        return 'Warranty';
      case AssetDocumentType.manual:
        return 'Manual';
      case AssetDocumentType.insurance:
        return 'Insurance';
      case AssetDocumentType.registration:
        return 'Registration';
      case AssetDocumentType.serviceRecord:
        return 'Service record';
      case AssetDocumentType.other:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
        elevation: 0,
        title: Text('Add document', style: AppTypography.heading),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('Add proof of ownership', style: AppTypography.title),

            const SizedBox(height: AppSpacing.sm),

            Text(
              'Scan a receipt or attach an existing ownership document.',
              style: AppTypography.bodySecondary,
            ),

            const SizedBox(height: AppSpacing.xl),

            _DocumentAction(
              icon: Icons.document_scanner_outlined,
              title: 'Scan receipt',
              subtitle: 'Capture or choose a receipt image',
              onTap: _scanReceipt,
            ),

            const SizedBox(height: AppSpacing.md),

            _DocumentAction(
              icon: Icons.upload_file_outlined,
              title: 'Choose file',
              subtitle: 'PDF, image or other document',
              onTap: _pickFile,
            ),

            if (_selectedFileName != null) ...[
              const SizedBox(height: AppSpacing.xl),

              Text('Selected', style: AppTypography.bodySecondary),

              const SizedBox(height: AppSpacing.sm),

              Text(
                _selectedFileName!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: AppSpacing.xl),

              DropdownButtonFormField<AssetDocumentType>(
                initialValue: _selectedType,
                decoration: const InputDecoration(labelText: 'Document type'),
                items: AssetDocumentType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(_typeLabel(type)),
                      ),
                    )
                    .toList(),
                onChanged: (type) {
                  if (type == null) return;

                  setState(() {
                    _selectedType = type;
                  });
                },
              ),

              const SizedBox(height: AppSpacing.xl),

              AppButton(label: 'Add document', onPressed: _saveDocument),
            ],
          ],
        ),
      ),
    );
  }
}

class _DocumentAction extends StatelessWidget {
  const _DocumentAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.accent),
            ),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(subtitle, style: AppTypography.bodySecondary),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
