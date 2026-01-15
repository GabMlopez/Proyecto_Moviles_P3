import 'package:flutter/material.dart';

class DonutPlaceholder extends StatelessWidget {
  const DonutPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      height: 92,
      child: CustomPaint(
        painter: _DonutPainter(),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final base = Paint()
      ..color = const Color(0xFFE9ECF3)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius - 7, base);

    final hole = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius - 22, hole);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
