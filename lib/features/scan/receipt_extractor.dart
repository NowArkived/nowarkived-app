import 'package:image_picker/image_picker.dart';

import 'receipt_extraction.dart';

class ReceiptExtractor {
  Future<ReceiptExtraction> extract(XFile image) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    return ReceiptExtraction(
      merchant: 'Apple Store',
      total: 1299.00,
      purchaseDate: DateTime.now(),
      rawText: '''
Apple Store
MacBook Pro
Total 1299.00
Thank you
''',
    );
  }
}
