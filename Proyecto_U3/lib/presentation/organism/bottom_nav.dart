import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onChanged,
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
          icon: Icon(Icons.auto_awesome_rounded),
          label: 'IA Insights',
        ),
      ],
    );
  }
}
