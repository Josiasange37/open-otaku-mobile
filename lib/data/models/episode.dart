/// Represents a single episode of an anime.
class Episode {
  const Episode({
    required this.id,
    required this.number,
    required this.title,
    required this.thumbnailUrl,
    required this.duration,
    this.watchedProgress = Duration.zero,
    required this.videoUrl,
    this.isDownloaded = false,
  });

  final String id;
  final int number;
  final String title;
  final String thumbnailUrl;
  final Duration duration;
  final Duration watchedProgress;
  final String videoUrl;
  final bool isDownloaded;

  double get watchedPercent {
    if (duration.inSeconds == 0) return 0;
    return watchedProgress.inSeconds / duration.inSeconds;
  }
}
