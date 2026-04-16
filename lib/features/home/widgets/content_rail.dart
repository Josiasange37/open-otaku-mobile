import 'package:flutter/material.dart';
import '../../../data/models/anime.dart';

/// Generic horizontal content rail.
class ContentRail extends StatelessWidget {
  const ContentRail({
    super.key,
    required this.animeList,
    required this.builder,
    this.height = 220,
  });

  final List<Anime> animeList;
  final Widget Function(Anime anime) builder;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: animeList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: builder(animeList[index]),
          );
        },
      ),
    );
  }
}
