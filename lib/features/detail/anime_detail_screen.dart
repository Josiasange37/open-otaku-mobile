import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../data/providers/anime_providers.dart';
import '../../data/models/anime.dart';
import '../../data/models/episode.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../core/widgets/tap_scale.dart';
import '../../core/widgets/gradient_overlay.dart';
import '../../core/widgets/pill_chip.dart';
import '../../core/utils/duration_formatter.dart';

class AnimeDetailScreen extends ConsumerStatefulWidget {
  const AnimeDetailScreen({super.key, required this.animeId});

  final String animeId;

  @override
  ConsumerState<AnimeDetailScreen> createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends ConsumerState<AnimeDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _synopsisExpanded = false;

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
    final anime = ref.watch(animeByIdProvider(widget.animeId));
    if (anime == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final episodes = ref.watch(episodesProvider(widget.animeId));
    final myList = ref.watch(myListProvider);
    final isInList = myList.contains(anime.id);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Parallax Backdrop
          SliverToBoxAdapter(
            child: Stack(
              children: [
                SizedBox(
                  height: screenWidth * 9 / 16 + 80,
                  child: CachedNetworkImage(
                    imageUrl: anime.backdropUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    memCacheWidth: (screenWidth * 2).toInt(),
                    placeholder: (_, __) =>
                        Container(color: AppColors.surface),
                    errorWidget: (_, __, ___) =>
                        Container(color: AppColors.surface),
                  ),
                ),
                const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: GradientOverlay(
                    height: 200,
                    stops: [0.0, 0.6, 1.0],
                  ),
                ),
                // Back button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 8,
                  child: TapScale(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.background.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          color: AppColors.textPrimary, size: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Title & Meta
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(anime.englishTitle,
                      style: AppTextStyles.headlineLarge),
                  if (anime.title != anime.englishTitle) ...[
                    const SizedBox(height: 4),
                    Text(anime.title,
                        style: AppTextStyles.bodyMedium),
                  ],
                  const SizedBox(height: 12),

                  // Meta row
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _metaItem(Icons.calendar_today_rounded,
                          anime.year.toString()),
                      _metaItem(Icons.tv_rounded,
                          '${anime.totalEpisodes} EP'),
                      _metaItem(Icons.star_rounded,
                          anime.rating.toStringAsFixed(1)),
                      _metaItem(Icons.shield_rounded, anime.ageRating),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Action bar
                  Row(
                    children: [
                      Expanded(
                        child: TapScale(
                          onTap: () {
                            if (episodes.isNotEmpty) {
                              context.push(
                                '/watch/${anime.id}/${episodes.first.id}',
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.primaryWithOpacity40,
                                  blurRadius: 24,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.play_arrow_rounded,
                                    color: Colors.white, size: 26),
                                const SizedBox(width: 8),
                                Text('Play',
                                    style: AppTextStyles.button
                                        .copyWith(fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _actionIcon(
                        isInList
                            ? Icons.check_rounded
                            : Icons.add_rounded,
                        isInList ? 'Listed' : 'List',
                        () => ref
                            .read(myListProvider.notifier)
                            .toggle(anime.id),
                      ),
                      _actionIcon(
                          Icons.download_rounded, 'Download', () {}),
                      _actionIcon(
                          Icons.share_rounded, 'Share', () {}),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Genre chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: anime.genres
                        .map((g) => PillChip(label: g))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Tabs
          SliverToBoxAdapter(
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Episodes'),
                Tab(text: 'Related'),
              ],
            ),
          ),

          // Tab content
          SliverToBoxAdapter(
            child: SizedBox(
              height: _tabController.index == 1
                  ? episodes.length * 90.0 + 48
                  : 400,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Overview
                  _buildOverview(anime),
                  // Episodes
                  _buildEpisodes(anime, episodes),
                  // Related
                  _buildRelated(),
                ],
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 48)),
        ],
      ),
    );
  }

  Widget _buildOverview(Anime anime) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            anime.synopsis,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: _synopsisExpanded ? null : 4,
            overflow:
                _synopsisExpanded ? null : TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () =>
                setState(() => _synopsisExpanded = !_synopsisExpanded),
            child: Text(
              _synopsisExpanded ? 'Show less' : 'Read more',
              style: AppTextStyles.labelMedium
                  .copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 24),
          _infoRow('Studio', anime.studio),
          _infoRow('Status', anime.status),
          _infoRow('Year', anime.year.toString()),
          _infoRow('Rating', '${anime.rating}/10'),
        ],
      ),
    );
  }

  Widget _buildEpisodes(Anime anime, List<Episode> episodes) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        final ep = episodes[index];
        return TapScale(
          onTap: () => context.push('/watch/${anime.id}/${ep.id}'),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: ep.thumbnailUrl,
                    width: 120,
                    height: 68,
                    fit: BoxFit.cover,
                    memCacheWidth: 240,
                    placeholder: (_, __) =>
                        Container(color: AppColors.surfaceElevated),
                    errorWidget: (_, __, ___) =>
                        Container(color: AppColors.surfaceElevated),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EP ${ep.number}',
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.primary),
                      ),
                      Text(
                        ep.title,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        DurationFormatter.formatVerbose(ep.duration),
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                Icon(
                  ep.isDownloaded
                      ? Icons.download_done_rounded
                      : Icons.download_for_offline_outlined,
                  color: ep.isDownloaded
                      ? AppColors.success
                      : AppColors.textMuted,
                  size: 22,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRelated() {
    final allAnime = ref.watch(animeListProvider);
    final related =
        allAnime.where((a) => a.id != widget.animeId).take(6).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.55,
      ),
      itemCount: related.length,
      itemBuilder: (context, index) {
        final anime = related[index];
        return TapScale(
          onTap: () => context.push('/anime/${anime.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: anime.posterUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    memCacheWidth: 240,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                anime.englishTitle,
                style: AppTextStyles.labelSmall
                    .copyWith(color: AppColors.textPrimary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _metaItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(text, style: AppTextStyles.bodySmall),
      ],
    );
  }

  Widget _actionIcon(IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TapScale(
        onTap: onTap,
        child: Column(
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 24),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.labelSmall),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: AppTextStyles.bodySmall),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
