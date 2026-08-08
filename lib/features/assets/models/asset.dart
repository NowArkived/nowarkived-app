import 'asset_document.dart';

class Asset {
  final String id;
  final String name;
  final String category;
  final String? serialNumber;
  final DateTime? purchaseDate;
  final DateTime? warrantyExpiry;
  final DateTime createdAt;
  final List<AssetDocument> documents;

  const Asset({
    required this.id,
    required this.name,
    required this.category,
    required this.createdAt,
    this.serialNumber,
    this.purchaseDate,
    this.warrantyExpiry,
    this.documents = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'serialNumber': serialNumber,
      'purchaseDate': purchaseDate?.toIso8601String(),
      'warrantyExpiry': warrantyExpiry?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'documents': documents.map((document) => document.toJson()).toList(),
    };
  }

  factory Asset.fromJson(Map<String, dynamic> json) {
    final documentData = json['documents'] as List<dynamic>? ?? [];

    return Asset(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      serialNumber: json['serialNumber'] as String?,
      purchaseDate: _parseDate(json['purchaseDate']),
      warrantyExpiry: _parseDate(json['warrantyExpiry']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      documents: documentData
          .map(
            (document) => AssetDocument.fromJson(
              Map<String, dynamic>.from(document as Map),
            ),
          )
          .toList(),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null || value is! String) {
      return null;
    }

    return DateTime.tryParse(value);
  }
}
