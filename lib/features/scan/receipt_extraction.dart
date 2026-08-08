class ReceiptExtraction {
  const ReceiptExtraction({
    this.merchant,
    this.total,
    this.purchaseDate,
    this.rawText,
  });

  final String? merchant;
  final double? total;
  final DateTime? purchaseDate;
  final String? rawText;
}
