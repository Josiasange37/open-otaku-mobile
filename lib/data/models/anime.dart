/// Represents an anime title with all metadata.
class Anime {
  const Anime({
    required this.id,
    required this.title,
    required this.englishTitle,
    required this.synopsis,
    required this.posterUrl,
    required this.backdropUrl,
    required this.rating,
    required this.year,
    required this.status,
    required this.genres,
    required this.totalEpisodes,
    required this.studio,
    required this.ageRating,
    this.isTrending = false,
    this.isNewSeason = false,
  });

  final String id;
  final String title;
  final String englishTitle;
  final String synopsis;
  final String posterUrl;
  final String backdropUrl;
  final double rating;
  final int year;
  final String status;
  final List<String> genres;
  final int totalEpisodes;
  final String studio;
  final String ageRating;
  final bool isTrending;
  final bool isNewSeason;
}
