import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Khung 4 tab bottom-nav, bao các route con qua go_router ShellRoute.
/// 4 tab: Home / Ôn từ / Bài học / Hồ sơ (theo recommend.md V1).
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  /// StatefulNavigationShell từ go_router — giữ state mỗi tab.
  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    _TabItem('/home', Icons.home_outlined, Icons.home, 'Trang chủ'),
    _TabItem('/vocab', Icons.style_outlined, Icons.style, 'Ôn từ'),
    _TabItem('/lessons', Icons.menu_book_outlined, Icons.menu_book, 'Bài học'),
    _TabItem('/profile', Icons.person_outline, Icons.person, 'Hồ sơ'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: [
          for (final tab in _tabs)
            BottomNavigationBarItem(
              icon: Icon(tab.icon),
              activeIcon: Icon(tab.activeIcon),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}

class _TabItem {
  const _TabItem(this.path, this.icon, this.activeIcon, this.label);
  final String path;
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
