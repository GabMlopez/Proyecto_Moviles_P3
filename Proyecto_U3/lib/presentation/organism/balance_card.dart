import 'package:flutter/material.dart';
import '../atom/app_card.dart';
import '../atom/chip_month.dart';
import '../atom/mini_stat.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Balance actual',
                  style: TextStyle(
                    color: Color(0xFF7B8494),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ChipMonth(label: 'January 2026', onTap: () {}),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '\$0.00',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(
                child: MiniStat(
                  title: 'INGRESOS',
                  value: '\$0.00',
                  valueColor: Color(0xFF14A44D),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: MiniStat(
                  title: 'GASTOS',
                  value: '\$0.00',
                  valueColor: Color(0xFFE74C3C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
