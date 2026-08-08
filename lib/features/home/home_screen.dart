import 'package:flutter/material.dart';

import '../../design/app_button.dart';
import '../../design/app_card.dart';
import '../../design/app_colors.dart';
import '../../design/app_spacing.dart';
import '../../design/app_typography.dart';
import '../assets/asset_detail_screen.dart';
import '../assets/create_asset_screen.dart';
import '../assets/data/sample_assets.dart';
import '../assets/models/asset.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<Asset> _assets;

  @override
  void initState() {
    super.initState();
    _assets = List<Asset>.from(sampleAssets);
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
  }

  IconData _iconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return Icons.laptop_mac_outlined;
      case 'documents':
        return Icons.description_outlined;
      case 'vehicles':
        return Icons.directions_car_outlined;
      default:
        return Icons.inventory_2_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
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

              const SizedBox(height: AppSpacing.xl),

              Expanded(
                child: ListView.separated(
                  itemCount: _assets.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final asset = _assets[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AssetDetailScreen(asset: asset),
                          ),
                        );
                      },
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    asset.name,
                                    style: AppTypography.body.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: AppSpacing.xs),

                                  Text(
                                    asset.category,
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
