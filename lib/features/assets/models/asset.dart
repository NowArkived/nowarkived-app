class Asset {
  final String id;
  final String name;
  final String category;
  final String? serialNumber;
  final DateTime? purchaseDate;
  final DateTime? warrantyExpiry;
  final DateTime createdAt;

  const Asset({
    required this.id,
    required this.name,
    required this.category,
    required this.createdAt,
    this.serialNumber,
    this.purchaseDate,
    this.warrantyExpiry,
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
    };
  }

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      serialNumber: json['serialNumber'] as String?,
      purchaseDate: _parseDate(json['purchaseDate']),
      warrantyExpiry: _parseDate(json['warrantyExpiry']),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null || value is! String) {
      return null;
    }

    return DateTime.tryParse(value);
  }
}