/// Formats a [Duration] into human-readable strings.
abstract final class DurationFormatter {
  /// Formats as mm:ss or hh:mm:ss.
  static String format(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  /// Formats as "Xh Ym" or "Ym" for display.
  static String formatVerbose(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Formats remaining time as "Xm left".
  static String formatRemaining(Duration total, Duration watched) {
    final remaining = total - watched;
    if (remaining.isNegative) return '0m left';
    final minutes = remaining.inMinutes;
    if (minutes < 1) return '<1m left';
    return '${minutes}m left';
  }
}
