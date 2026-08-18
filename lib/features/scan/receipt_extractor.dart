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

      return ReceiptExtraction(rawText: rawText.isEmpty ? null : rawText);
    } finally {
      await textRecognizer.close();
    }
  }
}
