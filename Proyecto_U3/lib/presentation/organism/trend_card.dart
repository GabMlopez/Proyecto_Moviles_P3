import 'package:flutter/material.dart';
import '../atom/app_card.dart';
import 'simple_line_chart.dart';

class TrendCard extends StatelessWidget {
  const TrendCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            'Tendencia (7 días)',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
        ),
        const SizedBox(height: 10),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Neto diario',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2B2F3A),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(height: 62, child: SimpleLineChart(

              )),
              SizedBox(height: 10),
              Text(
                'positivo = ahorras, negativo = gastas más de lo que\ningresas.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8B93A3),
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
