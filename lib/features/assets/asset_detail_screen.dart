import 'package:flutter/material.dart';

import '../../design/app_card.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import 'models/asset.dart';

class AssetDetailScreen extends StatelessWidget {
  const AssetDetailScreen({super.key, required this.asset});

  final Asset asset;

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _warrantyStatus(DateTime expiry) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final expiryDate = DateTime(expiry.year, expiry.month, expiry.day);

    final days = expiryDate.difference(today).inDays;

    if (days < 0) {
      return 'Expired';
    }

    if (days == 0) {
      return 'Expires today';
    }

    if (days == 1) {
      return '1 day remaining';
    }

    return '$days days remaining';
  }

  bool _isWarrantyExpired(DateTime expiry) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final expiryDate = DateTime(expiry.year, expiry.month, expiry.day);

    return expiryDate.isBefore(today);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
        elevation: 0,
        title: Text('Asset details', style: AppTypography.heading),
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

            Text(asset.name, style: AppTypography.title),

            const SizedBox(height: AppSpacing.sm),

            Text(asset.category, style: AppTypography.bodySecondary),

            const SizedBox(height: AppSpacing.xl),

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ownership', style: AppTypography.heading),

                  const SizedBox(height: AppSpacing.lg),

                  _DetailRow(label: 'Category', value: asset.category),

                  if (asset.serialNumber != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _DetailRow(
                      label: 'Serial number',
                      value: asset.serialNumber!,
                    ),
                  ],

                  if (asset.purchaseDate != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _DetailRow(
                      label: 'Purchased',
                      value: _formatDate(asset.purchaseDate!),
                    ),
                  ],

                  if (asset.warrantyExpiry != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _DetailRow(
                      label: 'Warranty',
                      value: _formatDate(asset.warrantyExpiry!),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    Text(
                      _warrantyStatus(asset.warrantyExpiry!),
                      style: AppTypography.bodySecondary.copyWith(
                        color: _isWarrantyExpired(asset.warrantyExpiry!)
                            ? AppColors.error
                            : AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.md),

                  _DetailRow(
                    label: 'Added',
                    value: _formatDate(asset.createdAt),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Documents', style: AppTypography.heading),

                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    'Receipts, warranties and manuals will appear here.',
                    style: AppTypography.bodySecondary,
                  ),
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
