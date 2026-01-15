import 'package:flutter/material.dart';
import '../atom/app_card.dart';
import 'donut_placeholder.dart';
import 'category_list.dart';

class SpendingCard extends StatelessWidget {
  const SpendingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            '¿En qué se va tu dinero?',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
        ),
        const SizedBox(height: 10),
        AppCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              DonutPlaceholder(),
              SizedBox(width: 16),
              Expanded(child: CategoryList()),
            ],
          ),
        ),
      ],
    );
  }
}
