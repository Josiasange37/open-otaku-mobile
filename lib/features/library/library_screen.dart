import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../data/providers/anime_providers.dart';
import '../../data/models/anime.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../core/widgets/tap_scale.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, topPadding + 16, 16, 8),
          child: Text('Library', style: AppTextStyles.headlineLarge),
        ),
        TabBar(
          controller: _tabController,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: 'Downloads'),
            Tab(text: 'My List'),
            Tab(text: 'History'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildDownloads(),
              _buildMyList(),
              _buildHistory(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDownloads() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Storage meter
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.storage_rounded,
                      color: AppColors.textPrimary, size: 20),
                  const SizedBox(width: 8),
                  Text('Storage', style: AppTextStyles.labelLarge),
                  const Spacer(),
                  Text('2.4 GB / 64 GB',
                      style: AppTextStyles.labelSmall),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const LinearProgressIndicator(
                  value: 0.037,
                  minHeight: 6,
                  backgroundColor: AppColors.surfaceElevated,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Downloaded episodes
        ...List.generate(3, (i) {
          final anime = ref.watch(animeListProvider)[i];
          return _downloadTile(anime, 'EP ${i + 1}', '${180 + i * 40} MB', '720p');
        }),
      ],
    );
  }

  Widget _downloadTile(Anime anime, String ep, String size, String quality) {
    return Dismissible(
      key: Key(anime.id + ep),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.danger,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: anime.posterUrl,
                width: 48,
                height: 64,
                fit: BoxFit.cover,
                memCacheWidth: 96,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(anime.englishTitle,
                      style: AppTextStyles.labelMedium
                          .copyWith(color: AppColors.textPrimary)),
                  Text(ep, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(quality,
                      style: AppTextStyles.labelSmall
                          .copyWith(fontSize: 9)),
                ),
                const SizedBox(height: 4),
                Text(size, style: AppTextStyles.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyList() {
    final myListIds = ref.watch(myListProvider);
    final allAnime = ref.watch(animeListProvider);
    final myAnime =
        allAnime.where((a) => myListIds.contains(a.id)).toList();

    if (myAnime.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bookmark_border_rounded,
                size: 64, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text('Your list is empty',
                style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text('Add anime to watch later',
                style: AppTextStyles.bodyMedium),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
        childAspectRatio: 0.55,
      ),
      itemCount: myAnime.length,
      itemBuilder: (context, index) {
        final anime = myAnime[index];
        return TapScale(
          onTap: () => context.push('/anime/${anime.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: anime.posterUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    memCacheWidth: 400,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                anime.englishTitle,
                style: AppTextStyles.labelMedium
                    .copyWith(color: AppColors.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistory() {
    final history = ref.watch(watchHistoryProvider);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final anime = history[index];
        return TapScale(
          onTap: () => context.push('/anime/${anime.id}'),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: anime.posterUrl,
                    width: 48,
                    height: 64,
                    fit: BoxFit.cover,
                    memCacheWidth: 96,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(anime.englishTitle,
                          style: AppTextStyles.labelMedium
                              .copyWith(color: AppColors.textPrimary)),
                      Text('Watched 2 days ago',
                          style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: AppColors.textMuted),
              ],
            ),
          ),
        );
      },
    );
  }
}
