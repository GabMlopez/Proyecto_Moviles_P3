import 'package:flutter/material.dart';
import '../organism/header_resumen.dart';
import '../organism/balance_card.dart';
import '../organism/trend_card.dart';
import '../organism/spending_card.dart';
import '../organism/last_movements_card.dart';
import '../organism/bottom_nav.dart';

class ResumenLayout extends StatefulWidget {
  const ResumenLayout({super.key});

  @override
  State<ResumenLayout> createState() => _ResumenLayoutState();
}

class _ResumenLayoutState extends State<ResumenLayout> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6F7FB);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: const [
            SliverToBoxAdapter(child: HeaderResumen()),
            SliverToBoxAdapter(child: SizedBox(height: 14)),
            SliverToBoxAdapter(child: BalanceCard()),
            SliverToBoxAdapter(child: SizedBox(height: 14)),
            SliverToBoxAdapter(child: TrendCard()),
            SliverToBoxAdapter(child: SizedBox(height: 14)),
            SliverToBoxAdapter(child: SpendingCard()),
            SliverToBoxAdapter(child: SizedBox(height: 14)),
            SliverToBoxAdapter(child: LastMovementsCard()),
            SliverToBoxAdapter(child: SizedBox(height: 18)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onChanged: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
