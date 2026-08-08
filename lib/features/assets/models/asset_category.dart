enum AssetCategory {
  electronics,
  vehicle,
  home,
  appliance,
  document,
  jewelry,
  other,
}

extension AssetCategoryLabel on AssetCategory {
  String get label {
    switch (this) {
      case AssetCategory.electronics:
        return 'Electronics';
      case AssetCategory.vehicle:
        return 'Vehicles';
      case AssetCategory.home:
        return 'Home';
      case AssetCategory.appliance:
        return 'Appliances';
      case AssetCategory.document:
        return 'Documents';
      case AssetCategory.jewelry:
        return 'Jewelry';
      case AssetCategory.other:
        return 'Other';
    }
  }
}
