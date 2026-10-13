import 'dart:math' as math;
import 'package:flutter/material.dart';

class RocketIllustration extends StatefulWidget {
  final double width;
  final double height;

  const RocketIllustration({
    super.key,
    this.width = 340,
    this.height = 360,
  });

  @override
  State<RocketIllustration> createState() => _RocketIllustrationState();
}

class _RocketIllustrationState extends State<RocketIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _RocketPainter(animationValue: _controller.value),
        );
      },
    );
  }
}

class _RocketPainter extends CustomPainter {
  final double animationValue;

  _RocketPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final center = Offset(w / 2, h * 0.44);

    // Floating bobbing motion
    final floatOffset = math.sin(animationValue * 2 * math.pi) * 5.0;
    final rocketCenter = Offset(center.dx, center.dy + floatOffset);

    // Flame flicker
    final flameScale = 0.95 + 0.1 * math.sin(animationValue * 6 * math.pi);

    // Star twinkle
    final starScale1 = 0.9 + 0.15 * math.sin(animationValue * 2 * math.pi);
    final starScale2 = 0.9 + 0.15 * math.cos(animationValue * 2 * math.pi);

    // 1. Draw Background Space Elements (Stars and Colored Dots)
    _drawSpaceElements(canvas, rocketCenter, starScale1, starScale2);

    // 2. Draw Clouds at the bottom (Background Layer)
    _drawClouds(canvas, Offset(center.dx, center.dy + 88));

    // 3. Draw Rocket Exhaust Flame
    _drawFlame(canvas, rocketCenter, flameScale);

    // 4. Draw Rocket Body and Fins
    _drawRocket(canvas, rocketCenter);

    // 5. Draw Foreground Cloud Puffs (soft overlap)
    _drawForegroundClouds(canvas, Offset(center.dx, center.dy + 88));
  }

  void _drawSpaceElements(
    Canvas canvas,
    Offset rocketCenter,
    double starScale1,
    double starScale2,
  ) {
    // Star 1: Golden Star (Upper Right)
    final star1Center = Offset(rocketCenter.dx + 68, rocketCenter.dy - 62);
    _drawFourPointStar(
      canvas,
      star1Center,
      radius: 12.0 * starScale1,
      color: const Color(0xFFFBBF24),
    );

    // Star 2: Cyan Star (Lower Left)
    final star2Center = Offset(rocketCenter.dx - 80, rocketCenter.dy + 72);
    _drawFourPointStar(
      canvas,
      star2Center,
      radius: 9.0 * starScale2,
      color: const Color(0xFF38BDF8),
    );

    // Dot 1: Orange/amber dot (Upper Left)
    final dot1 = Paint()
      ..color = const Color(0xFFF59E0B).withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(rocketCenter.dx - 76, rocketCenter.dy - 28),
      3.8,
      dot1,
    );

    // Dot 2: Lilac/Purple dot (Mid Right)
    final dot2 = Paint()
      ..color = const Color(0xFFA5B4FC).withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(rocketCenter.dx + 94, rocketCenter.dy - 8),
      3.2,
      dot2,
    );

    // Dot 3: Soft pink/coral dot (Lower Right)
    final dot3 = Paint()
      ..color = const Color(0xFFF472B6).withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(rocketCenter.dx + 82, rocketCenter.dy + 52),
      3.2,
      dot3,
    );
  }

  void _drawFourPointStar(
    Canvas canvas,
    Offset center, {
    required double radius,
    required Color color,
  }) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    // 4-point star created with quadratic bezier curves
    path.moveTo(center.dx, center.dy - radius);
    path.quadraticBezierTo(
      center.dx,
      center.dy,
      center.dx + radius,
      center.dy,
    );
    path.quadraticBezierTo(
      center.dx,
      center.dy,
      center.dx,
      center.dy + radius,
    );
    path.quadraticBezierTo(
      center.dx,
      center.dy,
      center.dx - radius,
      center.dy,
    );
    path.quadraticBezierTo(
      center.dx,
      center.dy,
      center.dx,
      center.dy - radius,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawFlame(Canvas canvas, Offset rocketCenter, double flameScale) {
    final flameOrigin = Offset(rocketCenter.dx, rocketCenter.dy + 46);
    final outerFlameLength = 54.0 * flameScale;
    final innerFlameLength = 34.0 * flameScale;

    // Outer flame (Warm Golden Orange)
    final outerFlamePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
      ).createShader(
        Rect.fromLTWH(
          flameOrigin.dx - 14,
          flameOrigin.dy,
          28,
          outerFlameLength,
        ),
      )
      ..style = PaintingStyle.fill;

    final outerPath = Path();
    outerPath.moveTo(flameOrigin.dx - 12, flameOrigin.dy);
    outerPath.quadraticBezierTo(
      flameOrigin.dx - 14,
      flameOrigin.dy + outerFlameLength * 0.5,
      flameOrigin.dx,
      flameOrigin.dy + outerFlameLength,
    );
    outerPath.quadraticBezierTo(
      flameOrigin.dx + 14,
      flameOrigin.dy + outerFlameLength * 0.5,
      flameOrigin.dx + 12,
      flameOrigin.dy,
    );
    outerPath.close();
    canvas.drawPath(outerPath, outerFlamePaint);

    // Inner flame (Bright Lemon Core)
    final innerFlamePaint = Paint()
      ..color = const Color(0xFFFEF08A)
      ..style = PaintingStyle.fill;

    final innerPath = Path();
    innerPath.moveTo(flameOrigin.dx - 6, flameOrigin.dy);
    innerPath.quadraticBezierTo(
      flameOrigin.dx - 7,
      flameOrigin.dy + innerFlameLength * 0.5,
      flameOrigin.dx,
      flameOrigin.dy + innerFlameLength,
    );
    innerPath.quadraticBezierTo(
      flameOrigin.dx + 7,
      flameOrigin.dy + innerFlameLength * 0.5,
      flameOrigin.dx + 6,
      flameOrigin.dy,
    );
    innerPath.close();
    canvas.drawPath(innerPath, innerFlamePaint);
  }

  void _drawRocket(Canvas canvas, Offset c) {
    const double bodyWidth = 46.0;
    final double bodyTop = c.dy - 38.0;
    final double bodyBottom = c.dy + 42.0;

    // --- 1. Left and Right Fins ---
    final finPaint = Paint()
      ..color = const Color(0xFF4338CA) // Deep royal blue
      ..style = PaintingStyle.fill;

    // Left fin
    final leftFinPath = Path();
    leftFinPath.moveTo(c.dx - 18, bodyBottom - 26);
    leftFinPath.cubicTo(
      c.dx - 34,
      bodyBottom - 18,
      c.dx - 40,
      bodyBottom + 4,
      c.dx - 36,
      bodyBottom + 16,
    );
    leftFinPath.quadraticBezierTo(
      c.dx - 28,
      bodyBottom + 12,
      c.dx - 16,
      bodyBottom - 2,
    );
    leftFinPath.close();
    canvas.drawPath(leftFinPath, finPaint);

    // Right fin (Symmetrical)
    final rightFinPath = Path();
    rightFinPath.moveTo(c.dx + 18, bodyBottom - 26);
    rightFinPath.cubicTo(
      c.dx + 34,
      bodyBottom - 18,
      c.dx + 40,
      bodyBottom + 4,
      c.dx + 36,
      bodyBottom + 16,
    );
    rightFinPath.quadraticBezierTo(
      c.dx + 28,
      bodyBottom + 12,
      c.dx + 18,
      bodyBottom - 2,
    );
    rightFinPath.close();
    canvas.drawPath(rightFinPath, finPaint);

    // --- 2. Rocket Fuselage (Blue Body) ---
    final bodyPaint = Paint()
      ..color = const Color(0xFF4F46E5) // Vibrant indigo / periwinkle blue
      ..style = PaintingStyle.fill;

    final bodyPath = Path();
    bodyPath.moveTo(c.dx - bodyWidth / 2, bodyBottom - 8);
    // Left curve up towards nose cone
    bodyPath.cubicTo(
      c.dx - bodyWidth / 2,
      bodyTop + 14,
      c.dx - bodyWidth * 0.45,
      bodyTop - 10,
      c.dx,
      bodyTop - 28,
    );
    // Right curve down
    bodyPath.cubicTo(
      c.dx + bodyWidth * 0.45,
      bodyTop - 10,
      c.dx + bodyWidth / 2,
      bodyTop + 14,
      c.dx + bodyWidth / 2,
      bodyBottom - 8,
    );
    // Bottom subtle curve
    bodyPath.quadraticBezierTo(
      c.dx,
      bodyBottom - 2,
      c.dx - bodyWidth / 2,
      bodyBottom - 8,
    );
    bodyPath.close();
    canvas.drawPath(bodyPath, bodyPaint);

    // --- 3. Nose Cone (Coral Red/Pink Tip) ---
    final nosePaint = Paint()
      ..color = const Color(0xFFF43F5E) // Bright coral rose
      ..style = PaintingStyle.fill;

    final nosePath = Path();
    final noseSplitY = bodyTop + 4.0;
    nosePath.moveTo(c.dx - bodyWidth * 0.42, noseSplitY);
    nosePath.cubicTo(
      c.dx - bodyWidth * 0.35,
      bodyTop - 12,
      c.dx - 8,
      bodyTop - 28,
      c.dx,
      bodyTop - 32,
    );
    nosePath.cubicTo(
      c.dx + 8,
      bodyTop - 28,
      c.dx + bodyWidth * 0.35,
      bodyTop - 12,
      c.dx + bodyWidth * 0.42,
      noseSplitY,
    );
    nosePath.quadraticBezierTo(
      c.dx,
      noseSplitY + 2,
      c.dx - bodyWidth * 0.42,
      noseSplitY,
    );
    nosePath.close();
    canvas.drawPath(nosePath, nosePaint);

    // --- 4. Engine Nozzle at Base ---
    final nozzlePaint = Paint()
      ..color = const Color(0xFF3730A3)
      ..style = PaintingStyle.fill;

    final nozzleRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(c.dx, bodyBottom - 3),
        width: 22,
        height: 8,
      ),
      const Radius.circular(3),
    );
    canvas.drawRRect(nozzleRect, nozzlePaint);

    // --- 5. Circular Porthole Window ---
    final windowCenter = Offset(c.dx, c.dy + 4);
    const windowRadius = 15.0;

    // Window Outer Ring (White/Light Periwinkle)
    final ringPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(windowCenter, windowRadius, ringPaint);

    // Window Inner Glass (Vibrant Cyan)
    final glassPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
      ).createShader(
        Rect.fromCircle(center: windowCenter, radius: windowRadius - 3.2),
      )
      ..style = PaintingStyle.fill;
    canvas.drawCircle(windowCenter, windowRadius - 3.2, glassPaint);

    // Window Glass Specular Reflection Highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(windowCenter.dx - 3.8, windowCenter.dy - 3.8),
      2.5,
      highlightPaint,
    );
  }

  void _drawClouds(Canvas canvas, Offset cloudOrigin) {
    // Soft blurred drop shadow behind clouds
    final shadowPaint = Paint()
      ..color = const Color(0xFF64748B).withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cloudOrigin.dx, cloudOrigin.dy + 4),
          width: 150,
          height: 48,
        ),
        const Radius.circular(24),
      ),
      shadowPaint,
    );

    // Cloud Base Puffs (Layer 1)
    final cloudPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..style = PaintingStyle.fill;

    // Left puff
    canvas.drawCircle(
      Offset(cloudOrigin.dx - 54, cloudOrigin.dy + 2),
      22,
      cloudPaint,
    );
    // Right puff
    canvas.drawCircle(
      Offset(cloudOrigin.dx + 54, cloudOrigin.dy + 3),
      21,
      cloudPaint,
    );
  }

  void _drawForegroundClouds(Canvas canvas, Offset cloudOrigin) {
    // Soft clean white puffs in front
    final cloudPuffPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.95)
      ..style = PaintingStyle.fill;

    // Left-mid puff
    canvas.drawCircle(
      Offset(cloudOrigin.dx - 32, cloudOrigin.dy),
      25,
      cloudPuffPaint,
    );

    // Right-mid puff
    canvas.drawCircle(
      Offset(cloudOrigin.dx + 30, cloudOrigin.dy + 2),
      24,
      cloudPuffPaint,
    );

    // Center main puff
    canvas.drawCircle(
      Offset(cloudOrigin.dx, cloudOrigin.dy + 4),
      28,
      cloudPuffPaint,
    );

    // Base horizontal pill blending
    final pillRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cloudOrigin.dx, cloudOrigin.dy + 10),
        width: 130,
        height: 34,
      ),
      const Radius.circular(17),
    );
    canvas.drawRRect(pillRect, cloudPuffPaint);
  }

  @override
  bool shouldRepaint(covariant _RocketPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
