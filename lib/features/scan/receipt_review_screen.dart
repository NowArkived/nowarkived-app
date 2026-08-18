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

  final _merchantController = TextEditingController();
  final _totalController = TextEditingController();

  ReceiptExtraction? _extraction;
  DateTime? _purchaseDate;

  bool _isExtracting = true;
  bool _showRawText = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _extractReceipt();
  }

  @override
  void dispose() {
    _merchantController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  Future<void> _extractReceipt() async {
    try {
      final extraction = await _extractor.extract(widget.receipt);

      if (!mounted) return;

      _merchantController.text = extraction.merchant ?? '';

      if (extraction.total != null) {
        _totalController.text = extraction.total!.toStringAsFixed(2);
      }

      setState(() {
        _extraction = extraction;
        _purchaseDate = extraction.purchaseDate;
        _isExtracting = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'We couldn’t read this receipt.';
        _isExtracting = false;
      });
    }
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

  void _useDetails() {
    final total = double.tryParse(
      _totalController.text.trim().replaceAll(',', '').replaceAll('₹', ''),
    );

    final extraction = ReceiptExtraction(
      merchant: _merchantController.text.trim().isEmpty
          ? null
          : _merchantController.text.trim(),
      total: total,
      purchaseDate: _purchaseDate,
      rawText: _extraction?.rawText,
    );

    Navigator.pop(context, extraction);
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
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isExtracting) {
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

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 32),

            const SizedBox(height: AppSpacing.md),

            Text(_errorMessage!, style: AppTypography.heading),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Check the details', style: AppTypography.title),

        const SizedBox(height: AppSpacing.sm),

        Text(
          'We extracted these details from your receipt. Correct anything that looks wrong.',
          style: AppTypography.bodySecondary,
        ),

        const SizedBox(height: AppSpacing.xl),

        TextField(
          controller: _merchantController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Merchant',
            hintText: 'Not found',
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        InkWell(
          onTap: _selectPurchaseDate,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
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
                      Text('Purchase date', style: AppTypography.bodySecondary),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _purchaseDate == null
                            ? 'Not found'
                            : _formatDate(_purchaseDate!),
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
        ),

        const SizedBox(height: AppSpacing.md),

        TextField(
          controller: _totalController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Total',
            hintText: 'Not found',
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        InkWell(
          onTap: () {
            setState(() {
              _showRawText = !_showRawText;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Raw receipt text',
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  _showRawText ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),

        if (_showRawText)
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _extraction?.rawText ?? 'No text found.',
                  style: AppTypography.bodySecondary,
                ),
              ),
            ),
          )
        else
          const Spacer(),

        const SizedBox(height: AppSpacing.lg),

        AppButton(label: 'Use these details', onPressed: _useDetails),
      ],
    );
  }
}
