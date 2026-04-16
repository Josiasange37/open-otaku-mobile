import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../data/providers/anime_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../core/utils/duration_formatter.dart';
import '../../core/utils/haptics.dart';

class WatchScreen extends ConsumerStatefulWidget {
  const WatchScreen({
    super.key,
    required this.animeId,
    required this.episodeId,
  });

  final String animeId;
  final String episodeId;

  @override
  ConsumerState<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends ConsumerState<WatchScreen> {
  late VideoPlayerController _videoController;
  bool _initialized = false;
  bool _showControls = true;
  bool _isLocked = false;
  Timer? _hideControlsTimer;
  String _selectedQuality = 'Auto';
  String _selectedSubtitle = 'Off';

  @override
  void initState() {
    super.initState();
    _enterImmersive();
    WakelockPlus.enable();
    _initVideo();
  }

  void _enterImmersive() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _exitImmersive() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void _initVideo() {
    final episodes = ref.read(episodesProvider(widget.animeId));
    final episode = episodes.firstWhere(
      (e) => e.id == widget.episodeId,
      orElse: () => episodes.first,
    );

    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(episode.videoUrl),
    )..initialize().then((_) {
        if (mounted) {
          setState(() => _initialized = true);
          _videoController.play();
          _startHideTimer();
        }
      });
  }

  void _startHideTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _videoController.value.isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    if (_isLocked) {
      setState(() => _showControls = !_showControls);
      if (_showControls) _startHideTimer();
      return;
    }
    setState(() => _showControls = !_showControls);
    if (_showControls) _startHideTimer();
  }

  void _togglePlayPause() {
    Haptics.light();
    if (_videoController.value.isPlaying) {
      _videoController.pause();
      _hideControlsTimer?.cancel();
      setState(() => _showControls = true);
    } else {
      _videoController.play();
      _startHideTimer();
    }
    setState(() {});
  }

  void _seekRelative(Duration offset) {
    Haptics.light();
    final current = _videoController.value.position;
    final target = current + offset;
    _videoController.seekTo(target);
    _startHideTimer();
  }

  void _showQualitySheet() {
    Haptics.medium();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Quality', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 16),
              ...['Auto', '1080p', '720p', '480p', '360p'].map((q) {
                final selected = q == _selectedQuality;
                return ListTile(
                  title: Text(q, style: AppTextStyles.bodyLarge),
                  trailing: selected
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.primary)
                      : null,
                  onTap: () {
                    Haptics.selection();
                    setState(() => _selectedQuality = q);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showSubtitleSheet() {
    Haptics.medium();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Subtitles', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 16),
              ...['Off', 'English', 'Spanish', 'Japanese'].map((s) {
                final selected = s == _selectedSubtitle;
                return ListTile(
                  title: Text(s, style: AppTextStyles.bodyLarge),
                  trailing: selected
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.primary)
                      : null,
                  onTap: () {
                    Haptics.selection();
                    setState(() => _selectedSubtitle = s);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _videoController.dispose();
    WakelockPlus.disable();
    _exitImmersive();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final anime = ref.watch(animeByIdProvider(widget.animeId));
    final episodes = ref.watch(episodesProvider(widget.animeId));
    final episode = episodes.firstWhere(
      (e) => e.id == widget.episodeId,
      orElse: () => episodes.first,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        onDoubleTapDown: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < screenWidth / 2) {
            _seekRelative(const Duration(seconds: -10));
          } else {
            _seekRelative(const Duration(seconds: 10));
          }
        },
        onDoubleTap: () {},
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video
            if (_initialized)
              Center(
                child: AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),

            // Buffering indicator
            if (_initialized && _videoController.value.isBuffering)
              const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3,
                ),
              ),

            // Controls overlay
            if (_showControls && !_isLocked)
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: SafeArea(
                    child: Column(
                      children: [
                        // Top row
                        _buildTopRow(anime?.englishTitle ?? '', episode.number),
                        const Spacer(),
                        // Center controls
                        _buildCenterControls(),
                        const Spacer(),
                        // Bottom row
                        _buildBottomRow(),
                      ],
                    ),
                  ),
                ),
              ),

            // Lock mode: just the unlock button
            if (_isLocked && _showControls)
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Haptics.medium();
                      setState(() => _isLocked = false);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceWithOpacity60,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock_open_rounded,
                              color: AppColors.textPrimary, size: 20),
                          const SizedBox(width: 8),
                          Text('Unlock',
                              style: AppTextStyles.labelMedium
                                  .copyWith(color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow(String title, int epNum) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back_rounded,
                color: AppColors.textPrimary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Episode $epNum',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.cast_rounded,
                color: AppColors.textPrimary, size: 22),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.more_vert_rounded,
                color: AppColors.textPrimary, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Rewind 10s
        GestureDetector(
          onTap: () => _seekRelative(const Duration(seconds: -10)),
          child: const Icon(Icons.replay_10_rounded,
              color: AppColors.textPrimary, size: 40),
        ),
        const SizedBox(width: 48),
        // Play/Pause
        GestureDetector(
          onTap: _togglePlayPause,
          child: Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryWithOpacity40,
                  blurRadius: 30,
                ),
              ],
            ),
            child: Icon(
              _initialized && _videoController.value.isPlaying
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              color: AppColors.textPrimary,
              size: 40,
            ),
          ),
        ),
        const SizedBox(width: 48),
        // Forward 10s
        GestureDetector(
          onTap: () => _seekRelative(const Duration(seconds: 10)),
          child: const Icon(Icons.forward_10_rounded,
              color: AppColors.textPrimary, size: 40),
        ),
      ],
    );
  }

  Widget _buildBottomRow() {
    final position = _initialized
        ? _videoController.value.position
        : Duration.zero;
    final duration = _initialized
        ? _videoController.value.duration
        : Duration.zero;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        children: [
          // Scrubber
          Row(
            children: [
              Text(
                DurationFormatter.format(position),
                style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textPrimary),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor:
                        AppColors.primary.withValues(alpha: 0.3),
                    thumbColor: AppColors.primary,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 7,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 16,
                    ),
                    trackHeight: 3,
                  ),
                  child: Slider(
                    value: duration.inMilliseconds > 0
                        ? position.inMilliseconds /
                            duration.inMilliseconds
                        : 0,
                    onChanged: (v) {
                      _videoController.seekTo(
                        Duration(
                          milliseconds:
                              (v * duration.inMilliseconds).toInt(),
                        ),
                      );
                    },
                    onChangeStart: (_) => _hideControlsTimer?.cancel(),
                    onChangeEnd: (_) => _startHideTimer(),
                  ),
                ),
              ),
              Text(
                DurationFormatter.format(duration),
                style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Icon row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _controlIcon(
                Icons.lock_outline_rounded,
                'Lock',
                () {
                  Haptics.medium();
                  setState(() {
                    _isLocked = true;
                    _showControls = false;
                  });
                },
              ),
              _controlIcon(
                Icons.subtitles_rounded,
                _selectedSubtitle,
                _showSubtitleSheet,
              ),
              _controlIcon(
                Icons.high_quality_rounded,
                _selectedQuality,
                _showQualitySheet,
              ),
              _controlIcon(
                Icons.speed_rounded,
                '1.0x',
                () {},
              ),
              _controlIcon(
                Icons.fullscreen_rounded,
                'Full',
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _controlIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textPrimary, size: 22),
          const SizedBox(height: 2),
          Text(label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 9,
              )),
        ],
      ),
    );
  }
}
