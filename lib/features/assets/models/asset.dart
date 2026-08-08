class Asset {
  final String id;
  final String name;
  final String category;
  final String? serialNumber;
  final String? purchaseDate;
  final String? warrantyExpiry;
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
      'purchaseDate': purchaseDate,
      'warrantyExpiry': warrantyExpiry,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      serialNumber: json['serialNumber'] as String?,
      purchaseDate: json['purchaseDate'] as String?,
      warrantyExpiry: json['warrantyExpiry'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}