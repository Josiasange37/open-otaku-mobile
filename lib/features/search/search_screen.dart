import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../data/providers/anime_providers.dart';
import '../../data/models/anime.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      ref.read(searchQueryProvider.notifier).state = _controller.text;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider);
    final topPadding = MediaQuery.of(context).padding.top;

    return Column(
      children: [
        // Search bar
        Padding(
          padding: EdgeInsets.fromLTRB(16, topPadding + 12, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: AppTextStyles.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'Search anime...',
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppColors.textMuted),
                      suffixIcon: query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded,
                                  color: AppColors.textMuted),
                              onPressed: () => _controller.clear(),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              if (query.isNotEmpty) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    _focusNode.unfocus();
                  },
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Results or trending
        Expanded(
          child: query.isEmpty
              ? _buildTrending()
              : results.isEmpty
                  ? _buildEmpty()
                  : _buildResults(results),
        ),
      ],
    );
  }

  Widget _buildTrending() {
    final allAnime = ref.watch(animeListProvider);
    final trending = allAnime.where((a) => a.isTrending).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        Text('Trending Searches',
            style: AppTextStyles.headlineSmall),
        const SizedBox(height: 12),
        ...trending.take(8).toList().asMap().entries.map((entry) {
          final i = entry.key;
          final anime = entry.value;
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 32,
              alignment: Alignment.center,
              child: Text(
                '${i + 1}',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: i < 3 ? AppColors.primary : AppColors.textMuted,
                ),
              ),
            ),
            title: Text(
              anime.englishTitle,
              style: AppTextStyles.bodyLarge,
            ),
            trailing: const Icon(Icons.trending_up_rounded,
                color: AppColors.textMuted, size: 18),
            onTap: () => context.push('/anime/${anime.id}'),
          );
        }),
      ],
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded,
              size: 64, color: AppColors.textMuted),
          const SizedBox(height: 16),
          Text('No results found',
              style: AppTextStyles.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildResults(List<Anime> results) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final anime = results[index];
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: anime.posterUrl,
              width: 48,
              height: 64,
              fit: BoxFit.cover,
              memCacheWidth: 96,
            ),
          ),
          title: Text(
            anime.englishTitle,
            style: AppTextStyles.labelLarge,
          ),
          subtitle: Text(
            '${anime.year} • ${anime.genres.take(2).join(', ')}',
            style: AppTextStyles.bodySmall,
          ),
          trailing: const Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: AppColors.textMuted),
          onTap: () => context.push('/anime/${anime.id}'),
        );
      },
    );
  }
}
