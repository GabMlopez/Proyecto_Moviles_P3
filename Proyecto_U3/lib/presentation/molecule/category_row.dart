import 'package:flutter/material.dart';

class CategoryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color dotColor;

  const CategoryRow({
    super.key,
    required this.label,
    required this.value,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF2B2F3A),
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            color: Color(0xFF2B2F3A),
          ),
        ),
      ],
    );
  }
}
