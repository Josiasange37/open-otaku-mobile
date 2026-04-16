import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/genre.dart';
import '../../../data/providers/anime_providers.dart';
import '../../../core/widgets/pill_chip.dart';
import '../../../core/utils/haptics.dart';

/// Horizontal scrollable genre chip strip.
class GenreStrip extends ConsumerWidget {
  const GenreStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedGenresProvider);

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: Genre.all.length,
        itemBuilder: (context, index) {
          final genre = Genre.all[index];
          final isSelected = selected.contains(genre);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PillChip(
              label: genre,
              selected: isSelected,
              onTap: () {
                Haptics.selection();
                final current = ref.read(selectedGenresProvider);
                final updated = {...current};
                if (isSelected) {
                  updated.remove(genre);
                } else {
                  updated.add(genre);
                }
                ref.read(selectedGenresProvider.notifier).state =
                    updated;
              },
            ),
          );
        },
      ),
    );
  }
}
