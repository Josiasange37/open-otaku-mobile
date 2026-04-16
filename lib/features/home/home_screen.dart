import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/anime_providers.dart';
import '../../theme/app_colors.dart';
import '../shell/top_bar.dart';
import 'widgets/hero_carousel.dart';
import 'widgets/continue_watching_rail.dart';
import 'widgets/genre_strip.dart';
import 'widgets/content_rail.dart';
import 'widgets/trending_rank_card.dart';
import 'widgets/anime_poster_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();
  double _topBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final newOpacity = (offset / 250).clamp(0.0, 1.0);
    if ((newOpacity - _topBarOpacity).abs() > 0.01) {
      setState(() => _topBarOpacity = newOpacity);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featured = ref.watch(featuredAnimeProvider);
    final continueWatching = ref.watch(continueWatchingProvider);
    final newSeason = ref.watch(newSeasonAnimeProvider);
    final topRated = ref.watch(topRatedAnimeProvider);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Hero Carousel
            SliverToBoxAdapter(
              child: HeroCarousel(animeList: featured),
            ),

            // Continue Watching
            if (continueWatching.isNotEmpty) ...[
              _sectionHeader('Continue Watching'),
              SliverToBoxAdapter(
                child: ContinueWatchingRail(items: continueWatching),
              ),
            ],

            // Genre Strip
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 24),
                child: GenreStrip(),
              ),
            ),

            // Trending Now
            _sectionHeader('Trending Now 🔥'),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: featured.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: TrendingRankCard(
                        anime: featured[index],
                        rank: index + 1,
                      ),
                    );
                  },
                ),
              ),
            ),

            // New This Season
            _sectionHeader('New This Season'),
            SliverToBoxAdapter(
              child: ContentRail(
                animeList: newSeason,
                builder: (anime) => AnimePosterCard(anime: anime),
              ),
            ),

            // Top Rated
            _sectionHeader('Top Rated ⭐'),
            SliverToBoxAdapter(
              child: ContentRail(
                animeList: topRated,
                builder: (anime) => AnimePosterCard(
                  anime: anime,
                  showRating: true,
                ),
              ),
            ),

            // Bottom spacing
            SliverPadding(
              padding: EdgeInsets.only(bottom: 100 + bottomPadding),
            ),
          ],
        ),

        // Floating top bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: TopBar(opacity: _topBarOpacity),
        ),
      ],
    );
  }

  SliverToBoxAdapter _sectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
