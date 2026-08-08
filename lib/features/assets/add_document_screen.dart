import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../design/app_button.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import 'models/asset_document.dart';

class AddDocumentScreen extends StatefulWidget {
  const AddDocumentScreen({super.key});

  @override
  State<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  PlatformFile? _selectedFile;
  AssetDocumentType _selectedType = AssetDocumentType.receipt;

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles();

    if (result == null || result.files.isEmpty) {
      return;
    }

    if (!mounted) return;

    setState(() {
      _selectedFile = result.files.first;
    });
  }

  void _saveDocument() {
    final file = _selectedFile;

    if (file == null) return;

    final document = AssetDocument(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: file.name,
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
              'Attach a receipt, warranty, manual, insurance document or other record.',
              style: AppTypography.bodySecondary,
            ),

            const SizedBox(height: AppSpacing.xl),

            InkWell(
              onTap: _pickFile,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
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
                      child: const Icon(
                        Icons.upload_file_outlined,
                        color: AppColors.accent,
                      ),
                    ),

                    const SizedBox(width: AppSpacing.md),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedFile?.name ?? 'Choose a file',
                            style: AppTypography.body.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: AppSpacing.xs),

                          Text(
                            _selectedFile == null
                                ? 'PDF, image or document'
                                : 'Tap to choose another file',
                            style: AppTypography.bodySecondary,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: AppSpacing.sm),

                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Text(
              'Document type',
              style: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: AppSpacing.sm),

            DropdownButtonFormField<AssetDocumentType>(
              initialValue: _selectedType,
              decoration: const InputDecoration(border: OutlineInputBorder()),
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

            AppButton(
              label: 'Add document',
              onPressed: _selectedFile == null ? null : _saveDocument,
            ),
          ],
        ),
      ),
    );
  }
}
