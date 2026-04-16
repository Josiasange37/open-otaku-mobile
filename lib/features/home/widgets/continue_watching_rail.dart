import 'package:flutter/material.dart';
import '../../../data/models/anime.dart';
import '../../../data/models/episode.dart';
import 'continue_watching_card.dart';

/// Horizontal rail of continue-watching cards.
class ContinueWatchingRail extends StatelessWidget {
  const ContinueWatchingRail({super.key, required this.items});

  final List<({Anime anime, Episode episode})> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ContinueWatchingCard(
              anime: item.anime,
              episode: item.episode,
            ),
          );
        },
      ),
    );
  }
}
