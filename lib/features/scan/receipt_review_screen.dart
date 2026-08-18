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
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _extractReceipt();
  }

  Future<void> _extractReceipt() async {
    try {
      final extraction = await _extractor.extract(widget.receipt);

      if (!mounted) return;

      setState(() {
        _extraction = extraction;
        _isExtracting = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'We couldn’t read this receipt.';
        _isExtracting = false;
      });
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
              'Recognizing the text on your document.',
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

    final extraction = _extraction!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Receipt text', style: AppTypography.title),

        const SizedBox(height: AppSpacing.sm),

        Text(
          'NowArkived found the following text.',
          style: AppTypography.bodySecondary,
        ),

        const SizedBox(height: AppSpacing.lg),

        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Text(
                extraction.rawText ?? 'No text found.',
                style: AppTypography.body,
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        AppButton(
          label: 'Use receipt',
          onPressed: extraction.rawText == null
              ? null
              : () {
                  Navigator.pop(context, extraction);
                },
        ),
      ],
    );
  }
}
