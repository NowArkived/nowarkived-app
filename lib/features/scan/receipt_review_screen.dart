import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../design/app_button.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import 'receipt_extraction.dart';
import 'receipt_extractor.dart';

class ReceiptReviewScreen extends StatefulWidget {
  const ReceiptReviewScreen({super.key, required this.receipt});

  final XFile receipt;

  @override
  State<ReceiptReviewScreen> createState() => _ReceiptReviewScreenState();
}

class _ReceiptReviewScreenState extends State<ReceiptReviewScreen> {
  final ReceiptExtractor _extractor = ReceiptExtractor();

  ReceiptExtraction? _extraction;
  bool _isExtracting = true;

  @override
  void initState() {
    super.initState();
    _extractReceipt();
  }

  Future<void> _extractReceipt() async {
    final extraction = await _extractor.extract(widget.receipt);

    if (!mounted) return;

    setState(() {
      _extraction = extraction;
      _isExtracting = false;
    });
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
        title: Text('Review receipt', style: AppTypography.heading),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: _isExtracting ? _buildExtracting() : _buildReview(),
        ),
      ),
    );
  }

  Widget _buildExtracting() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.accent),

          const SizedBox(height: AppSpacing.lg),

          Text('Reading your receipt', style: AppTypography.heading),

          const SizedBox(height: AppSpacing.sm),

          Text(
            'Finding merchant, purchase date and total.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildReview() {
    final extraction = _extraction!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Check the details', style: AppTypography.title),

        const SizedBox(height: AppSpacing.sm),

        Text(
          'Review extracted information before saving it.',
          style: AppTypography.bodySecondary,
        ),

        const SizedBox(height: AppSpacing.xl),

        _ExtractionRow(
          label: 'Merchant',
          value: extraction.merchant ?? 'Not found',
        ),

        const SizedBox(height: AppSpacing.md),

        _ExtractionRow(
          label: 'Purchase date',
          value: extraction.purchaseDate == null
              ? 'Not found'
              : _formatDate(extraction.purchaseDate!),
        ),

        const SizedBox(height: AppSpacing.md),

        _ExtractionRow(
          label: 'Total',
          value: extraction.total == null
              ? 'Not found'
              : extraction.total!.toStringAsFixed(2),
        ),

        const Spacer(),

        AppButton(
          label: 'Use these details',
          onPressed: () {
            Navigator.pop(context, extraction);
          },
        ),
      ],
    );
  }
}

class _ExtractionRow extends StatelessWidget {
  const _ExtractionRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.bodySecondary)),
          Text(
            value,
            style: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
