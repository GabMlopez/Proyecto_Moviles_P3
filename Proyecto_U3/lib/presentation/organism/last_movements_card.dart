import 'package:flutter/material.dart';
import '../atom/app_card.dart';

class LastMovementsCard extends StatelessWidget {
  const LastMovementsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            'Últimos movimientos',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
        ),
        const SizedBox(height: 10),
        const AppCard(
          child: Text(
            'Aún no hay movimientos. Ve a "Movimientos" para\nregistrar tu primer ingreso o gasto.',
            style: TextStyle(
              color: Color(0xFF8B93A3),
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}
