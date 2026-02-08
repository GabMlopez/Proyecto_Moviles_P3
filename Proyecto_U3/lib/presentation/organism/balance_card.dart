import 'package:flutter/material.dart';
import '../atom/app_card.dart';
import '../atom/chip_month.dart';
import '../atom/mini_stat.dart';

class BalanceCard extends StatelessWidget {
  final double ingresosTotales;
  final double gastosTotales;
  BalanceCard({super.key, required this.ingresosTotales, required this.gastosTotales});


  double calcularBalance()
  {
    return ingresosTotales - gastosTotales;
  }


  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
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
          SizedBox(height: 10),
          Text(
            '${calcularBalance().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: MiniStat(
                  title: 'INGRESOS',
                  value: "\$${ingresosTotales.toStringAsFixed(2)}",
                  valueColor: Color(0xFF14A44D),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: MiniStat(
                  title: 'GASTOS',
                  value: "\$${gastosTotales.toStringAsPrecision(2)}",
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
