import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import 'bottom_nav.dart';

/// The root scaffold shell with bottom navigation.
class MobileShell extends StatelessWidget {
  const MobileShell({super.key, required this.child});

  final Widget child;

  static int _indexFromPath(String path) {
    if (path.startsWith('/browse')) return 1;
    if (path.startsWith('/search')) return 2;
    if (path.startsWith('/library')) return 3;
    if (path.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location =
        GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFromPath(location);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: child,
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
            case 1:
              context.go('/browse');
            case 2:
              context.go('/search');
            case 3:
              context.go('/library');
            case 4:
              context.go('/profile');
          }
        },
      ),
    );
  }
}
