import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/anime_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'widgets/filter_chips.dart';
import 'widgets/sort_segmented.dart';
import 'widgets/poster_grid.dart';

class BrowseScreen extends ConsumerWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredAnimeProvider);
    final topPadding = MediaQuery.of(context).padding.top;

    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, topPadding + 16, 16, 8),
            child: Row(
              children: [
                Text('Browse', style: AppTextStyles.headlineLarge),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search_rounded,
                      color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ),

        // Filter chips
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: BrowseFilterChips(),
          ),
        ),

        // Sort segmented
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SortSegmented(),
          ),
        ),

        // Grid
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          sliver: PosterGrid(animeList: filtered),
        ),
      ],
    );
  }
}
