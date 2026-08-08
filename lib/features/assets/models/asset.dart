class Asset {
  final String id;
  final String name;
  final String category;
  final DateTime createdAt;

  const Asset({
    required this.id,
    required this.name,
    required this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}