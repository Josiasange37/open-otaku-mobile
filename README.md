# Open Otaku 🎌

A premium anime streaming client with a cinematic, native-feel dark UI built with Flutter.

![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?logo=dart)
![Android](https://img.shields.io/badge/Android-7.0+-3DDC84?logo=android)
![License](https://img.shields.io/badge/License-MIT-blue)

## ✨ Features

- **Cinematic Dark UI** — Premium near-black design with crimson accents and amber highlights
- **Hero Carousel** — Auto-advancing with crossfade transitions and page indicators
- **Continue Watching** — Episodes with progress bars and remaining time
- **Browse & Filter** — Multi-genre filtering with sorting (Popular / New / Top Rated)
- **Live Search** — Instant results with trending suggestions
- **Anime Detail** — Parallax backdrop, tabbed content (Overview / Episodes / Related)
- **Custom Video Player** — Immersive fullscreen with:
  - Landscape orientation lock
  - Double-tap ±10s seek
  - Quality & subtitle selectors
  - Screen lock mode
  - Wakelock integration
  - Custom scrubber with glassmorphic controls
- **Library** — Downloads with storage meter, My List, Watch History
- **Profile** — Stats, Premium promo, Settings groups with switches
- **Buttery Animations** — TapScale micro-interactions, animated nav pills, spring transitions

## 🏗️ Architecture

```
lib/
├── app.dart                    # Root MaterialApp
├── main.dart                   # Entry point
├── router/                     # GoRouter with ShellRoute
├── theme/                      # Color tokens, typography, theme
├── core/
│   ├── utils/                  # Haptics, duration formatters
│   └── widgets/                # TapScale, GlassContainer, Shimmer, etc.
├── data/
│   ├── models/                 # Anime, Episode, Genre
│   ├── mock/                   # 20+ realistic mock entries
│   └── providers/              # Riverpod state management
└── features/
    ├── shell/                  # MobileShell, BottomNav, TopBar
    ├── home/                   # Hero, Continue Watching, Rails
    ├── browse/                 # Filter chips, Sort, Poster grid
    ├── search/                 # Live search, Trending
    ├── detail/                 # Anime detail with tabs
    ├── watch/                  # Custom video player
    ├── library/                # Downloads, My List, History
    └── profile/                # Settings, Premium promo
```

## 🚀 Getting Started

```bash
# Install dependencies
flutter pub get

# Run on connected device / emulator
flutter run

# Build release APK
flutter build apk --release
```

## 📱 Requirements

- Flutter 3.24+
- Dart 3.5+
- Android SDK 24+ (Android 7.0 Nougat)

## 🎨 Design System

| Token | Value | Usage |
|-------|-------|-------|
| `background` | `#0A0A0B` | App background |
| `surface` | `#141416` | Cards, containers |
| `primary` | `#FF3D2E` | Crimson — CTAs, accents |
| `accent` | `#F5B544` | Amber — ratings, badges |
| `textPrimary` | `#FAFAFA` | Headings, labels |
| `textSecondary` | `#A1A1AA` | Body text |
| `textMuted` | `#6B6B75` | Captions, hints |

**Typography:** Space Grotesk (headings) + Inter (body/UI)

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management |
| `go_router` | Declarative routing with ShellRoute |
| `cached_network_image` | Image caching with placeholders |
| `video_player` | Video playback |
| `google_fonts` | Custom typography |
| `wakelock_plus` | Keep screen on during playback |

## 🔧 CI/CD

GitHub Actions workflow at `.github/workflows/build.yml`:

| Stage | Runner | Output |
|-------|--------|--------|
| **Analyze & Test** | `ubuntu-latest` | Code analysis + test coverage |
| **Build Android** | `ubuntu-latest` | Universal APK + split-per-ABI APKs |
| **Build iOS** | `macos-latest` | Unsigned `.ipa` (sideloadable) |
| **Release** *(on `v*` tag)* | `ubuntu-latest` | GitHub Release with APK + IPA |

**Trigger a build**: push to `main`, open a PR, or click "Run workflow" manually.
**Create a release**: `git tag v1.0.0 && git push --tags`

---

## 📲 Installing on Android

1. Go to your repo → **Actions** → latest successful run
2. Download the `open-otaku-apk-universal` artifact
3. Transfer the `.apk` to your phone
4. Open it and tap **Install** (enable "Install from unknown sources" if prompted)

---

## 🍎 Installing on iOS (without the App Store)

The CI/CD pipeline produces an unsigned `.ipa`. To install it on your iPhone/iPad, you **sign it on-device** using a free sideloading tool. No jailbreak needed.

### Option A: AltStore (recommended, fully free)

1. **Download AltServer** on your Mac/PC → [altstore.io](https://altstore.io)
2. Connect your iPhone via USB, install AltStore to your phone through AltServer
3. Download the `open-otaku-ios-unsigned.ipa` from GitHub Actions artifacts
4. Open AltStore on your iPhone → **My Apps** → tap **+** → select the `.ipa`
5. Sign in with your Apple ID when prompted — done!

> **Note:** With a free Apple ID, apps expire after **7 days**. Just re-install via AltStore (AltServer can auto-refresh if your phone and computer are on the same Wi-Fi). With a paid Apple Developer account ($99/year), apps last **365 days**.

### Option B: Sideloadly (Mac/Windows)

1. Download **Sideloadly** → [sideloadly.io](https://sideloadly.io)
2. Connect your iPhone via USB
3. Drag the `.ipa` into Sideloadly
4. Enter your Apple ID → click **Start**
5. On your iPhone: **Settings → General → VPN & Device Management** → trust your Apple ID profile

### Option C: Apple Developer Account ($99/year)

With a paid developer account, you get two better options:

| Method | Limit | Duration |
|--------|-------|----------|
| **TestFlight** | 10,000 testers | 90 days per build |
| **Ad Hoc** | 100 devices/year | 365 days |

For TestFlight: upload the `.ipa` to App Store Connect → invite testers via email/link.

### Troubleshooting

| Issue | Fix |
|-------|-----|
| "Untrusted Developer" | Settings → General → VPN & Device Management → Trust |
| App crashes on launch | Re-sign with latest AltStore version |
| "App ID limit reached" | Free Apple IDs allow 3 sideloaded apps max. Delete one first |
| Expired after 7 days | Re-install via AltStore (or upgrade to paid dev account) |

---

## License

MIT
