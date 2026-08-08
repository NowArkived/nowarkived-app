import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/asset.dart';

class AssetStorage {
  static const String _assetsKey = 'nowarkived_assets';

  static Future<List<Asset>?> loadAssets() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_assetsKey)) {
      return null;
    }

    final storedAssets = prefs.getString(_assetsKey);

    if (storedAssets == null) {
      return null;
    }

    final decoded = jsonDecode(storedAssets) as List<dynamic>;

    return decoded
        .map(
          (item) => Asset.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  static Future<void> saveAssets(List<Asset> assets) async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(
      assets.map((asset) => asset.toJson()).toList(),
    );

    await prefs.setString(_assetsKey, encoded);
  }
}