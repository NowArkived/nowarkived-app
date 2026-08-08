import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../design/app_button.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import 'receipt_extraction.dart';
import 'receipt_review_screen.dart';

class ReceiptScanResult {
  const ReceiptScanResult({required this.receipt, required this.extraction});

  final XFile receipt;
  final ReceiptExtraction extraction;
}

class ReceiptScannerScreen extends StatefulWidget {
  const ReceiptScannerScreen({super.key});

  @override
  State<ReceiptScannerScreen> createState() => _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends State<ReceiptScannerScreen> {
  final ImagePicker _picker = ImagePicker();

  XFile? _receipt;

  Future<void> _chooseReceipt() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (image == null) return;
    if (!mounted) return;

    setState(() {
      _receipt = image;
    });
  }

  Future<void> _continue() async {
    final receipt = _receipt;

    if (receipt == null) return;

    final extraction = await Navigator.push<ReceiptExtraction>(
      context,
      MaterialPageRoute(builder: (_) => ReceiptReviewScreen(receipt: receipt)),
    );

    if (extraction == null) return;
    if (!mounted) return;

    Navigator.pop(
      context,
      ReceiptScanResult(receipt: receipt, extraction: extraction),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
        elevation: 0,
        title: Text('Scan receipt', style: AppTypography.heading),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Capture your receipt', style: AppTypography.title),

              const SizedBox(height: AppSpacing.sm),

              Text(
                'Choose a clear receipt image so NowArkived can extract the important details.',
                style: AppTypography.bodySecondary,
              ),

              const SizedBox(height: AppSpacing.xl),

              Expanded(
                child: InkWell(
                  onTap: _chooseReceipt,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _receipt == null
                        ? const _EmptyReceiptState()
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              _receipt!.path,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                      AppSpacing.lg,
                                    ),
                                    child: Text(
                                      _receipt!.name,
                                      textAlign: TextAlign.center,
                                      style: AppTypography.body,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ),
              ),

              if (_receipt != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  _receipt!.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySecondary,
                ),
              ],

              const SizedBox(height: AppSpacing.lg),

              AppButton(
                label: _receipt == null ? 'Choose receipt' : 'Extract details',
                onPressed: _receipt == null ? _chooseReceipt : _continue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyReceiptState extends StatelessWidget {
  const _EmptyReceiptState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 28,
                color: AppColors.accent,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            Text('No receipt selected', style: AppTypography.heading),

            const SizedBox(height: AppSpacing.sm),

            Text(
              'Choose a clear receipt image to continue.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySecondary,
            ),
          ],
        ),
      ),
    );
  }
}
