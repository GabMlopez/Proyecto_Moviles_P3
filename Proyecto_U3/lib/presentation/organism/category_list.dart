import 'package:flutter/material.dart';
import '../molecule/category_row.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CategoryRow(label: 'Sueldo', value: '\$0.00', dotColor: Color(0xFF2ECC71)),
        SizedBox(height: 10),
        CategoryRow(label: 'Freelance', value: '\$0.00', dotColor: Color(0xFF27AE60)),
        SizedBox(height: 10),
        CategoryRow(label: 'Regalo', value: '\$0.00', dotColor: Color(0xFF16A085)),
        SizedBox(height: 10),
        CategoryRow(label: 'Otros', value: '\$0.00', dotColor: Color(0xFF0E8F7E)),
        SizedBox(height: 10),
        CategoryRow(label: 'Comida', value: '\$0.00', dotColor: Color(0xFFF39C12)),
      ],
    );
  }
}
