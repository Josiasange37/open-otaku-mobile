import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/anime.dart';
import '../models/episode.dart';
import '../mock/mock_anime.dart';

// ── Sort options ──

enum SortOption { popular, newest, topRated }

// ── Core providers ──

final animeListProvider = Provider<List<Anime>>((ref) {
  return mockAnimeList;
});

final featuredAnimeProvider = Provider<List<Anime>>((ref) {
  final all = ref.watch(animeListProvider);
  return all.where((a) => a.isTrending).toList();
});

final newSeasonAnimeProvider = Provider<List<Anime>>((ref) {
  final all = ref.watch(animeListProvider);
  return all.where((a) => a.isNewSeason).toList();
});

final topRatedAnimeProvider = Provider<List<Anime>>((ref) {
  final all = ref.watch(animeListProvider);
  final sorted = [...all]..sort((a, b) => b.rating.compareTo(a.rating));
  return sorted.take(10).toList();
});

final continueWatchingProvider =
    Provider<List<({Anime anime, Episode episode})>>((ref) {
  return mockContinueWatching;
});

final episodesProvider =
    Provider.family<List<Episode>, String>((ref, animeId) {
  return mockEpisodesMap[animeId] ?? [];
});

final animeByIdProvider =
    Provider.family<Anime?, String>((ref, id) {
  final all = ref.watch(animeListProvider);
  try {
    return all.firstWhere((a) => a.id == id);
  } catch (_) {
    return null;
  }
});

// ── Browse/filter state ──

final selectedGenresProvider = StateProvider<Set<String>>((ref) => {});

final sortOptionProvider =
    StateProvider<SortOption>((ref) => SortOption.popular);

final filteredAnimeProvider = Provider<List<Anime>>((ref) {
  final all = ref.watch(animeListProvider);
  final genres = ref.watch(selectedGenresProvider);
  final sort = ref.watch(sortOptionProvider);

  var filtered = genres.isEmpty
      ? all
      : all
          .where((a) => a.genres.any((g) => genres.contains(g)))
          .toList();

  switch (sort) {
    case SortOption.popular:
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    case SortOption.newest:
      filtered.sort((a, b) => b.year.compareTo(a.year));
    case SortOption.topRated:
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
  }

  return filtered;
});

// ── Search state ──

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = Provider<List<Anime>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  if (query.isEmpty) return [];
  final all = ref.watch(animeListProvider);
  return all.where((a) {
    return a.title.toLowerCase().contains(query) ||
        a.englishTitle.toLowerCase().contains(query) ||
        a.genres.any((g) => g.toLowerCase().contains(query));
  }).toList();
});

// ── My List state ──

final myListProvider =
    StateNotifierProvider<MyListNotifier, List<String>>((ref) {
  return MyListNotifier();
});

class MyListNotifier extends StateNotifier<List<String>> {
  MyListNotifier()
      : super(['demon-slayer', 'frieren', 'steins-gate']);

  void toggle(String animeId) {
    if (state.contains(animeId)) {
      state = state.where((id) => id != animeId).toList();
    } else {
      state = [...state, animeId];
    }
  }

  bool contains(String animeId) => state.contains(animeId);
}

// ── Watch history (mock) ──

final watchHistoryProvider = Provider<List<Anime>>((ref) {
  final all = ref.watch(animeListProvider);
  return all.take(5).toList();
});
