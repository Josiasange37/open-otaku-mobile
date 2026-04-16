import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/anime.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../core/widgets/tap_scale.dart';

/// Trending card with giant outlined rank numeral overlapping the poster.
class TrendingRankCard extends StatelessWidget {
  const TrendingRankCard({
    super.key,
    required this.anime,
    required this.rank,
  });

  final Anime anime;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: () => context.push('/anime/${anime.id}'),
      child: SizedBox(
        width: 170,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Giant rank numeral with stroke effect
            SizedBox(
              width: 55,
              child: Stack(
                children: [
                  // Stroke layer (outlined text)
                  Text(
                    rank.toString().padLeft(2, '0'),
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 90,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                      letterSpacing: -4,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Poster
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 2 / 3,
                      child: CachedNetworkImage(
                        imageUrl: anime.posterUrl,
                        fit: BoxFit.cover,
                        memCacheWidth: 240,
                        placeholder: (_, __) =>
                            Container(color: AppColors.surface),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.surface,
                          child: const Icon(Icons.movie_rounded,
                              color: AppColors.textMuted),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    anime.englishTitle,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
