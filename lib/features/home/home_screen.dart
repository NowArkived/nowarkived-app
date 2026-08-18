import 'package:flutter/material.dart';

import '../../design/app_button.dart';
import '../../design/app_card.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import '../assets/asset_detail_screen.dart';
import '../assets/create_asset_screen.dart';
import '../assets/data/asset_storage.dart';
import '../assets/data/sample_assets.dart';
import '../assets/models/asset.dart';
import '../reminders/warranty_reminder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  List<Asset> _assets = [];
  String _searchQuery = '';
  bool _isLoading = true;

  List<Asset> get _filteredAssets {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return _assets;
    }

    return _assets.where((asset) {
      final matchesName = asset.name.toLowerCase().contains(query);
      final matchesCategory = asset.category.toLowerCase().contains(query);
      final matchesSerial =
          asset.serialNumber?.toLowerCase().contains(query) ?? false;

      final matchesDocument = asset.documents.any(
        (document) => document.name.toLowerCase().contains(query),
      );

      return matchesName || matchesCategory || matchesSerial || matchesDocument;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAssets() async {
    final storedAssets = await AssetStorage.loadAssets();
    final assets = storedAssets ?? List<Asset>.from(sampleAssets);

    if (storedAssets == null) {
      await AssetStorage.saveAssets(assets);
    }

    if (!mounted) return;

    setState(() {
      _assets = assets;
      _isLoading = false;
    });
  }

  Future<void> _openCreateAsset() async {
    final asset = await Navigator.push<Asset>(
      context,
      MaterialPageRoute(builder: (_) => const CreateAssetScreen()),
    );

    if (asset == null) return;

    setState(() {
      _assets.insert(0, asset);
    });

    await AssetStorage.saveAssets(_assets);
  }

  Future<void> _openAsset(Asset asset) async {
    final result = await Navigator.push<AssetDetailResult>(
      context,
      MaterialPageRoute(builder: (_) => AssetDetailScreen(asset: asset)),
    );

    if (result == null) return;

    if (result.deleted) {
      setState(() {
        _assets.removeWhere((item) => item.id == asset.id);
      });

      await AssetStorage.saveAssets(_assets);
      return;
    }

    final updatedAsset = result.asset;

    if (updatedAsset == null) return;

    final index = _assets.indexWhere((item) => item.id == updatedAsset.id);

    if (index == -1) return;

    setState(() {
      _assets[index] = updatedAsset;
    });

    await AssetStorage.saveAssets(_assets);
  }

  IconData _iconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return Icons.laptop_mac_outlined;
      case 'documents':
        return Icons.description_outlined;
      case 'vehicles':
        return Icons.directions_car_outlined;
      case 'home':
        return Icons.home_outlined;
      case 'appliances':
        return Icons.kitchen_outlined;
      case 'jewelry':
        return Icons.diamond_outlined;
      default:
        return Icons.inventory_2_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredAssets = _filteredAssets;
    final reminders = buildWarrantyReminders(_assets);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),

              Text('Your assets', style: AppTypography.title),

              const SizedBox(height: AppSpacing.sm),

              Text(
                '${_assets.length} items organized in one place.',
                style: AppTypography.bodySecondary,
              ),

              const SizedBox(height: AppSpacing.lg),

              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search your things',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                  ),
                  suffixIcon: _searchQuery.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();

                            setState(() {
                              _searchQuery = '';
                            });
                          },
                          icon: const Icon(Icons.close),
                        ),
                ),
              ),

              if (!_isLoading &&
                  reminders.isNotEmpty &&
                  _searchQuery.isEmpty) ...[
                const SizedBox(height: AppSpacing.lg),

                Text('Attention', style: AppTypography.heading),

                const SizedBox(height: AppSpacing.sm),

                SizedBox(
                  height: 92,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: reminders.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final reminder = reminders[index];
                      final expired =
                          reminder.status == WarrantyReminderStatus.expired;

                      return InkWell(
                        onTap: () => _openAsset(reminder.asset),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 280,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            border: Border.all(
                              color: expired
                                  ? AppColors.error
                                  : AppColors.warning,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                expired
                                    ? Icons.error_outline
                                    : Icons.schedule_outlined,
                                color: expired
                                    ? AppColors.error
                                    : AppColors.warning,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      reminder.asset.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.body.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      reminder.message,
                                      style: AppTypography.bodySecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.lg),

              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accent,
                        ),
                      )
                    : filteredAssets.isEmpty
                    ? Center(
                        child: Text(
                          'No assets found',
                          style: AppTypography.heading,
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredAssets.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final asset = filteredAssets[index];

                          return GestureDetector(
                            onTap: () => _openAsset(asset),
                            child: AppCard(
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      _iconForCategory(asset.category),
                                      color: AppColors.accent,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          asset.name,
                                          style: AppTypography.body.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: AppSpacing.xs),
                                        Text(
                                          asset.documents.isEmpty
                                              ? asset.category
                                              : '${asset.category} · '
                                                    '${asset.documents.length} '
                                                    '${asset.documents.length == 1 ? 'document' : 'documents'}',
                                          style: AppTypography.bodySecondary,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: AppSpacing.md),

              AppButton(label: 'Add asset', onPressed: _openCreateAsset),
            ],
          ),
        ),
      ),
    );
  }
}
