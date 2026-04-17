import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/anime.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../core/widgets/tap_scale.dart';
import '../../../core/widgets/gradient_overlay.dart';
import '../../../core/widgets/pill_chip.dart';

/// Auto-advancing hero carousel with crossfade transitions.
class HeroCarousel extends StatefulWidget {
  const HeroCarousel({super.key, required this.animeList});

  final List<Anime> animeList;

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer.periodic(
      const Duration(seconds: 6),
      (_) => _advancePage(),
    );
  }

  void _advancePage() {
    if (!mounted) return;
    final next = (_currentPage + 1) % widget.animeList.length;
    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heroHeight = MediaQuery.of(context).size.height * 0.65;

    return SizedBox(
      height: heroHeight,
      child: Stack(
        children: [
          // Image pages
          PageView.builder(
            controller: _pageController,
            itemCount: widget.animeList.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              _startAutoAdvance();
            },
            itemBuilder: (context, index) {
              final anime = widget.animeList[index];
              return _HeroSlide(anime: anime);
            },
          ),

          // Bottom gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GradientOverlay(
              height: heroHeight * 0.7,
              stops: const [0.0, 0.5, 1.0],
            ),
          ),

          // Content overlay
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Genre chips
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: widget.animeList[_currentPage].genres
                      .take(3)
                      .map((g) => PillChip(
                            label: g,
                            selected: false,
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),

                // Title
                Text(
                  widget.animeList[_currentPage].englishTitle,
                  style: AppTextStyles.displayMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: TapScale(
                        onTap: () => context.push(
                          '/anime/${widget.animeList[_currentPage].id}',
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.primaryWithOpacity40,
                                blurRadius: 20,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.play_arrow_rounded,
                                  color: AppColors.textPrimary, size: 22),
                              const SizedBox(width: 6),
                              Text('Watch Now',
                                  style: AppTextStyles.button),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Page indicator dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.animeList.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _currentPage ? 24 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == _currentPage
                            ? AppColors.primary
                            : AppColors.textMuted.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSlide extends StatelessWidget {
  const _HeroSlide({required this.anime});

  final Anime anime;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: anime.backdropUrl,
      fit: BoxFit.cover,
      memCacheWidth: (MediaQuery.of(context).size.width * 2).toInt(),
      placeholder: (_, __) => Container(color: AppColors.surface),
      errorWidget: (_, __, ___) => Container(
        color: AppColors.surface,
        child: const Center(
          child: Icon(Icons.movie_rounded,
              color: AppColors.textMuted, size: 48),
        ),
      ),
    );
  }
}
