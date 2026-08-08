enum AssetDocumentType {
  receipt,
  warranty,
  manual,
  insurance,
  registration,
  serviceRecord,
  other,
}

class AssetDocument {
  final String id;
  final String name;
  final AssetDocumentType type;
  final DateTime createdAt;

  const AssetDocument({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AssetDocument.fromJson(Map<String, dynamic> json) {
    return AssetDocument(
      id: json['id'] as String,
      name: json['name'] as String,
      type: AssetDocumentType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => AssetDocumentType.other,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
