import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import 'receipt_extraction.dart';

class ReceiptExtractor {
  Future<ReceiptExtraction> extract(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      final rawText = recognizedText.text.trim();

      if (rawText.isEmpty) {
        return const ReceiptExtraction();
      }

      return ReceiptExtraction(
        merchant: _extractMerchant(rawText),
        total: _extractTotal(rawText),
        purchaseDate: _extractDate(rawText),
        rawText: rawText,
      );
    } finally {
      await textRecognizer.close();
    }
  }

  String? _extractMerchant(String text) {
    final lines = _cleanLines(text);

    for (final line in lines.take(5)) {
      final lower = line.toLowerCase();

      final looksLikeMetadata =
          lower.contains('invoice') ||
          lower.contains('receipt') ||
          lower.contains('gstin') ||
          lower.contains('tax invoice') ||
          RegExp(r'^\d+$').hasMatch(line);

      if (!looksLikeMetadata && line.length >= 3) {
        return line;
      }
    }

    return lines.isEmpty ? null : lines.first;
  }

  double? _extractTotal(String text) {
    final lines = _cleanLines(text);

    final totalKeywords = [
      'grand total',
      'amount payable',
      'amount paid',
      'net amount',
      'total amount',
      'total',
    ];

    for (final keyword in totalKeywords) {
      for (final line in lines.reversed) {
        if (!line.toLowerCase().contains(keyword)) {
          continue;
        }

        final amounts = _amountsFromLine(line);

        if (amounts.isNotEmpty) {
          return amounts.last;
        }
      }
    }

    return null;
  }

  DateTime? _extractDate(String text) {
    final patterns = [
      RegExp(r'\b(\d{1,2})[/-](\d{1,2})[/-](\d{4})\b'),
      RegExp(r'\b(\d{4})[/-](\d{1,2})[/-](\d{1,2})\b'),
    ];

    for (var index = 0; index < patterns.length; index++) {
      final match = patterns[index].firstMatch(text);

      if (match == null) continue;

      try {
        if (index == 0) {
          return DateTime(
            int.parse(match.group(3)!),
            int.parse(match.group(2)!),
            int.parse(match.group(1)!),
          );
        }

        return DateTime(
          int.parse(match.group(1)!),
          int.parse(match.group(2)!),
          int.parse(match.group(3)!),
        );
      } catch (_) {
        continue;
      }
    }

    return null;
  }

  List<String> _cleanLines(String text) {
    return text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  List<double> _amountsFromLine(String line) {
    final matches = RegExp(
      r'(?:₹|Rs\.?|INR|\$|€|£)?\s*(\d[\d,]*\.\d{2})',
      caseSensitive: false,
    ).allMatches(line);

    return matches
        .map((match) => double.tryParse(match.group(1)!.replaceAll(',', '')))
        .whereType<double>()
        .toList();
  }
}
