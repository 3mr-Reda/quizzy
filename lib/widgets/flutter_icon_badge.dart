import 'package:flutter/material.dart';

class FlutterWhiteLogo extends StatelessWidget {
  final double size;
  const FlutterWhiteLogo({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _FlutterLogoPainter(),
      ),
    );
  }
}

class _FlutterLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Top chevron
    final topChevron = Path();
    topChevron.moveTo(w * 0.9, 0);
    topChevron.lineTo(w * 0.35, h * 0.55);
    topChevron.lineTo(w * 0.55, h * 0.75);
    topChevron.lineTo(w, h * 0.3);
    topChevron.close();
    canvas.drawPath(topChevron, paint);

    // Bottom left chevron
    final bottomChevron = Path();
    bottomChevron.moveTo(w * 0.55, h * 0.75);
    bottomChevron.lineTo(w * 0.35, h * 0.95);
    bottomChevron.lineTo(w * 0.55, h * 1.0);
    bottomChevron.lineTo(w * 0.8, h * 0.75);
    bottomChevron.close();
    canvas.drawPath(bottomChevron, paint);

    // Bottom right chevron
    final lowerSlash = Path();
    lowerSlash.moveTo(w * 0.45, h * 0.65);
    lowerSlash.lineTo(w * 0.65, h * 0.85);
    lowerSlash.lineTo(w * 0.95, h * 0.55);
    lowerSlash.lineTo(w * 0.75, h * 0.35);
    lowerSlash.close();
    canvas.drawPath(lowerSlash, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
