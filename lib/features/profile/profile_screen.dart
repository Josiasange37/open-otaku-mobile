import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../core/widgets/tap_scale.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return ListView(
      padding: EdgeInsets.fromLTRB(16, topPadding + 16, 16, 120),
      children: [
        Text('Profile', style: AppTextStyles.headlineLarge),
        const SizedBox(height: 20),

        // Guest header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Avatar with gradient ring
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryGlow],
                  ),
                ),
                child: const CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.surfaceElevated,
                  child: Icon(Icons.person_rounded,
                      color: AppColors.textMuted, size: 32),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Guest',
                        style: AppTextStyles.headlineMedium),
                    const SizedBox(height: 4),
                    Text('Sign in to sync your data',
                        style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              TapScale(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text('Sign In',
                      style: AppTextStyles.labelMedium
                          .copyWith(color: AppColors.textPrimary)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Stats row
        Row(
          children: [
            _statItem('42', 'Watched'),
            _statItem('168', 'Hours'),
            _statItem('3', 'In List'),
          ],
        ),
        const SizedBox(height: 20),

        // Premium promo
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryGlow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.workspace_premium_rounded,
                      color: Colors.amberAccent, size: 28),
                  const SizedBox(width: 8),
                  Text('Otaku+',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      )),
                ],
              ),
              const SizedBox(height: 12),
              _perkRow('• Ad-free streaming experience'),
              _perkRow('• Download in 1080p quality'),
              _perkRow('• Early access to new seasons'),
              const SizedBox(height: 16),
              TapScale(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Go Premium',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Settings groups
        _settingsGroup('Playback', [
          _settingsRow(Icons.high_quality_rounded, 'Default Quality',
              trailing: 'Auto'),
          _settingsRow(Icons.skip_next_rounded, 'Autoplay Next',
              isSwitch: true, switchValue: true),
          _settingsRow(Icons.fast_forward_rounded, 'Skip Intro',
              isSwitch: true, switchValue: false),
          _settingsRow(Icons.data_saver_on_rounded, 'Data Saver',
              isSwitch: true, switchValue: false),
        ]),

        _settingsGroup('Downloads', [
          _settingsRow(Icons.download_rounded, 'Download Quality',
              trailing: '720p'),
          _settingsRow(Icons.wifi_rounded, 'Download Over Wi-Fi Only',
              isSwitch: true, switchValue: true),
          _settingsRow(Icons.folder_rounded, 'Storage Location',
              trailing: 'Internal'),
        ]),

        _settingsGroup('Preferences', [
          _settingsRow(Icons.language_rounded, 'Language',
              trailing: 'English'),
          _settingsRow(Icons.subtitles_rounded, 'Subtitles',
              trailing: 'English'),
          _settingsRow(Icons.notifications_rounded, 'Notifications',
              isSwitch: true, switchValue: true),
        ]),

        _settingsGroup('About', [
          _settingsRow(Icons.info_outline_rounded, 'Version',
              trailing: '1.0.0'),
          _settingsRow(Icons.article_outlined, 'Terms of Service'),
          _settingsRow(Icons.privacy_tip_outlined, 'Privacy Policy'),
        ]),
      ],
    );
  }

  Widget _statItem(String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: AppTextStyles.headlineLarge
                    .copyWith(color: AppColors.primary)),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }

  Widget _perkRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: AppTextStyles.bodyMedium
            .copyWith(color: Colors.white.withValues(alpha: 0.9)),
      ),
    );
  }

  Widget _settingsGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.labelMedium),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _settingsRow(
    IconData icon,
    String title, {
    String? trailing,
    bool isSwitch = false,
    bool switchValue = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyLarge
                  .copyWith(color: AppColors.textPrimary),
            ),
          ),
          if (isSwitch)
            Switch(
              value: switchValue,
              onChanged: (_) {},
              activeTrackColor: AppColors.primary,
            )
          else if (trailing != null)
            Text(trailing, style: AppTextStyles.bodySmall)
          else
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted, size: 20),
        ],
      ),
    );
  }
}
