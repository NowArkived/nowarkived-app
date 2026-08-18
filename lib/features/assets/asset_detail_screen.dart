import 'package:flutter/material.dart';

import '../../design/app_button.dart';
import '../../design/app_card.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import 'add_document_screen.dart';
import 'edit_asset_screen.dart';
import 'models/asset.dart';
import 'models/asset_document.dart';

class AssetDetailResult {
  const AssetDetailResult.updated(this.asset) : deleted = false;

  const AssetDetailResult.deleted() : asset = null, deleted = true;

  final Asset? asset;
  final bool deleted;
}

class AssetDetailScreen extends StatefulWidget {
  const AssetDetailScreen({super.key, required this.asset});

  final Asset asset;

  @override
  State<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends State<AssetDetailScreen> {
  late Asset _asset;

  @override
  void initState() {
    super.initState();
    _asset = widget.asset;
  }

  Future<void> _addDocument() async {
    final document = await Navigator.push<AssetDocument>(
      context,
      MaterialPageRoute(builder: (_) => const AddDocumentScreen()),
    );

    if (document == null) return;

    setState(() {
      _asset = _asset.copyWith(documents: [..._asset.documents, document]);
    });
  }

  Future<void> _editAsset() async {
    final updatedAsset = await Navigator.push<Asset>(
      context,
      MaterialPageRoute(builder: (_) => EditAssetScreen(asset: _asset)),
    );

    if (updatedAsset == null) return;

    setState(() {
      _asset = updatedAsset;
    });
  }

  Future<void> _deleteDocument(AssetDocument document) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text('Remove document?', style: AppTypography.heading),
          content: Text(
            'This will remove ${document.name} from this asset.',
            style: AppTypography.body,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Cancel', style: AppTypography.body),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                'Remove',
                style: AppTypography.body.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _asset = _asset.copyWith(
        documents: _asset.documents
            .where((item) => item.id != document.id)
            .toList(),
      );
    });
  }

  Future<void> _deleteAsset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text('Delete asset?', style: AppTypography.heading),
          content: Text(
            'This will remove ${_asset.name} and its saved document records.',
            style: AppTypography.body,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Cancel', style: AppTypography.body),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                'Delete',
                style: AppTypography.body.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    Navigator.pop(context, const AssetDetailResult.deleted());
  }

  void _goBack() {
    Navigator.pop(context, AssetDetailResult.updated(_asset));
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _warrantyStatus(DateTime expiry) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final expiryDate = DateTime(expiry.year, expiry.month, expiry.day);

    final days = expiryDate.difference(today).inDays;

    if (days < 0) return 'Expired';
    if (days == 0) return 'Expires today';
    if (days == 1) return '1 day remaining';

    return '$days days remaining';
  }

  bool _isWarrantyExpired(DateTime expiry) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final expiryDate = DateTime(expiry.year, expiry.month, expiry.day);

    return expiryDate.isBefore(today);
  }

  String _documentTypeLabel(AssetDocumentType type) {
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

  IconData _documentIcon(AssetDocumentType type) {
    switch (type) {
      case AssetDocumentType.receipt:
        return Icons.receipt_long_outlined;
      case AssetDocumentType.warranty:
        return Icons.verified_outlined;
      case AssetDocumentType.manual:
        return Icons.menu_book_outlined;
      case AssetDocumentType.insurance:
        return Icons.shield_outlined;
      case AssetDocumentType.registration:
        return Icons.badge_outlined;
      case AssetDocumentType.serviceRecord:
        return Icons.build_outlined;
      case AssetDocumentType.other:
        return Icons.description_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: _goBack,
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('Asset details', style: AppTypography.heading),
        actions: [
          IconButton(
            tooltip: 'Edit asset',
            onPressed: _editAsset,
            icon: const Icon(Icons.edit_outlined),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _deleteAsset();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: Text(
                  'Delete asset',
                  style: AppTypography.body.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: AppColors.accent,
                size: 28,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            Text(_asset.name, style: AppTypography.title),

            const SizedBox(height: AppSpacing.sm),

            Text(_asset.category, style: AppTypography.bodySecondary),

            const SizedBox(height: AppSpacing.xl),

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ownership', style: AppTypography.heading),

                  const SizedBox(height: AppSpacing.lg),

                  _DetailRow(label: 'Category', value: _asset.category),

                  if (_asset.serialNumber != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _DetailRow(
                      label: 'Serial number',
                      value: _asset.serialNumber!,
                    ),
                  ],

                  if (_asset.purchaseDate != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _DetailRow(
                      label: 'Purchased',
                      value: _formatDate(_asset.purchaseDate!),
                    ),
                  ],

                  if (_asset.warrantyExpiry != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _DetailRow(
                      label: 'Warranty',
                      value: _formatDate(_asset.warrantyExpiry!),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    Text(
                      _warrantyStatus(_asset.warrantyExpiry!),
                      style: AppTypography.bodySecondary.copyWith(
                        color: _isWarrantyExpired(_asset.warrantyExpiry!)
                            ? AppColors.error
                            : AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.md),

                  _DetailRow(
                    label: 'Added',
                    value: _formatDate(_asset.createdAt),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('Documents', style: AppTypography.heading),
                      ),
                      Text(
                        '${_asset.documents.length}',
                        style: AppTypography.bodySecondary,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  if (_asset.documents.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      child: Text(
                        'No documents added yet.',
                        style: AppTypography.bodySecondary,
                      ),
                    )
                  else
                    ..._asset.documents.map(
                      (document) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _documentIcon(document.type),
                                color: AppColors.accent,
                              ),

                              const SizedBox(width: AppSpacing.md),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      document.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.body.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    const SizedBox(height: AppSpacing.xs),

                                    Text(
                                      _documentTypeLabel(document.type),
                                      style: AppTypography.bodySecondary,
                                    ),
                                  ],
                                ),
                              ),

                              IconButton(
                                tooltip: 'Remove document',
                                onPressed: () {
                                  _deleteDocument(document);
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: AppColors.textSecondary,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: AppSpacing.sm),

                  AppButton(label: 'Add document', onPressed: _addDocument),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label, style: AppTypography.bodySecondary)),

        const SizedBox(width: AppSpacing.md),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
