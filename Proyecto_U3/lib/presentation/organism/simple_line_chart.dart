import 'package:flutter/material.dart';

class SimpleLineChart extends StatelessWidget {
  const SimpleLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LinePainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final points = <Offset>[
      Offset(0.05 * size.width, 0.65 * size.height),
      Offset(0.22 * size.width, 0.65 * size.height),
      Offset(0.39 * size.width, 0.64 * size.height),
      Offset(0.56 * size.width, 0.65 * size.height),
      Offset(0.73 * size.width, 0.65 * size.height),
      Offset(0.90 * size.width, 0.65 * size.height),
    ];

    final linePaint = Paint()
      ..color = const Color(0xFF2E6BFF)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);

    final dotFill = Paint()..color = Colors.white;
    final dotStroke = Paint()
      ..color = const Color(0xFF2E6BFF)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final p in points) {
      canvas.drawCircle(p, 5.5, dotFill);
      canvas.drawCircle(p, 5.5, dotStroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
