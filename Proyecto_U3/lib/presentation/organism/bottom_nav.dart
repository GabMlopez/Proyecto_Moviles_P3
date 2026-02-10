import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNav({
    super.key,
    required this.navigationShell,
  });

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: _goBranch,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF2E6BFF),
      unselectedItemColor: const Color(0xFF9AA3B2),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_rounded),
          label: 'Resumen',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_rounded),
          label: 'Movimientos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box_outlined),
          label: 'Cuenta',
        ),
      ],
    );
  }
}