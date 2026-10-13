import 'dart:math' as math;
import 'package:flutter/material.dart';

class LightbulbIcon extends StatelessWidget {
  final double size;
  const LightbulbIcon({super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LightbulbPainter(),
      ),
    );
  }
}

class _LightbulbPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final center = Offset(w / 2, h * 0.52);
    final bulbRadius = w * 0.28;

    final rayPaint = Paint()
      ..color = const Color(0xFFF5A623)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final bulbFillPaint = Paint()
      ..color = const Color(0xFFFDB022)
      ..style = PaintingStyle.fill;

    // Draw radiant rays around the top of the bulb
    final rayAngles = [
      -math.pi / 2,        // Top (vertical)
      -math.pi * 0.72,     // Top-left
      -math.pi * 0.28,     // Top-right
      -math.pi * 0.92,     // Left
      -math.pi * 0.08,     // Right
    ];

    final innerRayDist = bulbRadius + 3.5;
    final outerRayDist = bulbRadius + 8.0;

    for (final angle in rayAngles) {
      final start = Offset(
        center.dx + math.cos(angle) * innerRayDist,
        center.dy + math.sin(angle) * innerRayDist,
      );
      final end = Offset(
        center.dx + math.cos(angle) * outerRayDist,
        center.dy + math.sin(angle) * outerRayDist,
      );
      canvas.drawLine(start, end, rayPaint);
    }

    // Draw bulb body (circle on top, tapering neck at bottom)
    final bulbPath = Path();
    // Circle top
    bulbPath.addArc(
      Rect.fromCircle(center: center, radius: bulbRadius),
      math.pi * 0.22,
      math.pi * 1.56,
    );

    // Tapering to base
    final neckWidth = bulbRadius * 0.75;
    final neckBottom = center.dy + bulbRadius * 1.35;

    bulbPath.lineTo(center.dx + neckWidth / 2, neckBottom);
    bulbPath.lineTo(center.dx - neckWidth / 2, neckBottom);
    bulbPath.close();

    canvas.drawPath(bulbPath, bulbFillPaint);

    // Bulb base screw thread
    final basePaint = Paint()
      ..color = const Color(0xFFE08E00)
      ..style = PaintingStyle.fill;

    final baseRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, neckBottom + 2.5),
        width: neckWidth * 0.7,
        height: 3.5,
      ),
      const Radius.circular(1.5),
    );
    canvas.drawRRect(baseRect, basePaint);

    // Subtle bulb filament glow / inner highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(center.dx - bulbRadius * 0.3, center.dy - bulbRadius * 0.3),
      bulbRadius * 0.32,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
