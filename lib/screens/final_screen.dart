import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/question_model.dart';
import 'home_screen.dart';
import 'quiz_in_progress_screen.dart';
import 'review_answers_screen.dart';

// Aliases for backwards-compatibility across the app
typedef FinalTimesUpScreen = FinalScreen;
typedef ResultScreen = FinalScreen;
typedef Result = FinalScreen;
typedef Final = FinalScreen;

/// Final Screen (Time's Up)
///
/// Features:
/// - Joyful celebrating character illustration with colorful confetti
/// - "Time's Up!" title and "You answered all the questions" subtitle
/// - Circular score progress indicator (e.g. 8/10, 80%) with vibrant green arc
/// - "Correct" stat card with green checkmark badge
/// - "Wrong" stat card with red close badge
/// - "Try Again" primary action button
/// - "Home" secondary outlined action button
/// - Optional "Review Answers" action when question history is available
class FinalScreen extends StatelessWidget {
  final QuizCategory category;
  final int score;
  final int totalQuestions;
  final List<QuizQuestion> questions;
  final List<int?> userAnswers;
  final bool isTimeUp;

  const FinalScreen({
    super.key,
    this.category = const QuizCategory(
      id: 'flutter',
      title: 'Flutter',
      color: Color(0xFF0284C7),
      isFlutterLogo: true,
    ),
    this.score = 8,
    this.totalQuestions = 10,
    this.questions = const [],
    this.userAnswers = const [],
    this.isTimeUp = true,
  });

  @override
  Widget build(BuildContext context) {
    final int wrongCount = math.max(0, totalQuestions - score);
    final int percentage =
        totalQuestions > 0 ? ((score / totalQuestions) * 100).round() : 0;
    final double progressRatio =
        totalQuestions > 0 ? (score / totalQuestions).clamp(0.0, 1.0) : 0.0;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),

                          // 1. Celebrating Character Illustration with Confetti
                          const _CelebratingCharacter(),

                          const SizedBox(height: 20),

                          // 2. Title and Subtitle
                          Text(
                            "Time's Up!",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'You answered all the questions',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF64748B),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // 3. Circular Score Gauge (8/10, 80%)
                          _buildCircularProgress(progressRatio, percentage),

                          const SizedBox(height: 36),

                          // 4. Correct Answers Card
                          _buildStatCard(
                            isCorrect: true,
                            label: 'Correct',
                            count: score,
                          ),

                          const SizedBox(height: 12),

                          // 5. Wrong Answers Card
                          _buildStatCard(
                            isCorrect: false,
                            label: 'Wrong',
                            count: wrongCount,
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  // 6. Action Buttons: Try Again, Home, Review Answers
                  _buildBottomActions(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Circular Progress Ring with Score & Percentage
  Widget _buildCircularProgress(double ratio, int percentage) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(140, 140),
            painter: _CircularProgressPainter(
              progress: ratio,
              trackColor: const Color(0xFFE2E8F0),
              progressColor: const Color(0xFF22C55E),
              strokeWidth: 12,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score/$totalQuestions',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$percentage%',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF22C55E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Stat Card (Correct / Wrong)
  Widget _buildStatCard({
    required bool isCorrect,
    required String label,
    required int count,
  }) {
    final Color badgeColor =
        isCorrect ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
    final IconData badgeIcon =
        isCorrect ? Icons.check_rounded : Icons.close_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Badge
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              badgeIcon,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 14),

          // Label
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF334155),
            ),
          ),

          const Spacer(),

          // Count Value
          Text(
            '$count',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  /// Bottom Buttons: Try Again + Home + Review Answers
  Widget _buildBottomActions(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Try Again Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => QuizInProgressScreen(category: category),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5961E8),
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: const Color(0xFF5961E8).withValues(alpha: 0.35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Try Again',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // 2. Home Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF5961E8),
              side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Home',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5961E8),
              ),
            ),
          ),
        ),

        // Optional Review Answers Link
        if (questions.isNotEmpty) ...[
          const SizedBox(height: 4),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ReviewAnswersScreen(
                    questions: questions,
                    userAnswers: userAnswers,
                    category: category,
                    score: score,
                  ),
                ),
              );
            },
            child: Text(
              'Review Answers',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
        ] else
          const SizedBox(height: 10),

        // iOS Home Indicator
        Container(
          width: 135,
          height: 5,
          decoration: BoxDecoration(
            color: const Color(0xFFD1D5DB),
            borderRadius: BorderRadius.circular(2.5),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

/// Custom Circular Progress Painter
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  const _CircularProgressPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress Arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      const startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.trackColor != trackColor;
  }
}

/// Joyful Celebrating Character with Confetti Painter
class _CelebratingCharacter extends StatelessWidget {
  const _CelebratingCharacter();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 180,
      height: 140,
      child: CustomPaint(
        size: Size(180, 140),
        painter: _CelebratingCharacterPainter(),
      ),
    );
  }
}

class _CelebratingCharacterPainter extends CustomPainter {
  const _CelebratingCharacterPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    // ── 1. Confetti Particles ──────────────────────────────────────────────
    // Yellow star top center
    _drawStar(canvas, Offset(centerX - 5, 20), 7, const Color(0xFFFBBF24));
    // Purple star top right
    _drawStar(canvas, Offset(centerX + 35, 28), 5.5, const Color(0xFF818CF8));
    // Orange dot top right
    canvas.drawCircle(
      Offset(centerX + 50, 24),
      4,
      Paint()..color = const Color(0xFFFB923C),
    );
    // Blue pill/bar top left
    _drawRotatedRect(
      canvas,
      Offset(centerX - 38, 26),
      const Size(8, 4),
      -0.4,
      const Color(0xFF60A5FA),
    );
    // Pink rectangle left
    _drawRotatedRect(
      canvas,
      Offset(centerX - 60, 68),
      const Size(5, 9),
      0.3,
      const Color(0xFFEC4899),
    );
    // Green rectangle right
    _drawRotatedRect(
      canvas,
      Offset(centerX + 62, 34),
      const Size(9, 4),
      0.2,
      const Color(0xFF22C55E),
    );
    // Blue dot right
    canvas.drawCircle(
      Offset(centerX + 60, 64),
      4.5,
      Paint()..color = const Color(0xFF3B82F6),
    );
    // Small pink dot top left
    canvas.drawCircle(
      Offset(centerX - 55, 22),
      3.5,
      Paint()..color = const Color(0xFFF43F5E),
    );

    // ── 2. Arms (Raised Celebration V-Pose) ─────────────────────────────────
    final armPaint = Paint()
      ..color = const Color(0xFF3B82F6) // Vibrant blue sleeve
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Left arm: from shoulder upward-left
    canvas.drawLine(
      Offset(centerX - 16, 76),
      Offset(centerX - 38, 44),
      armPaint,
    );

    // Right arm: from shoulder upward-right
    canvas.drawLine(
      Offset(centerX + 16, 76),
      Offset(centerX + 38, 44),
      armPaint,
    );

    // Left hand (yellow circle)
    final handPaint = Paint()..color = const Color(0xFFFDE047);
    canvas.drawCircle(Offset(centerX - 42, 39), 6.5, handPaint);

    // Right hand (yellow circle)
    canvas.drawCircle(Offset(centerX + 42, 39), 6.5, handPaint);

    // ── 3. Torso (Blue Sweater / Shirt) ────────────────────────────────────
    final torsoPaint = Paint()..color = const Color(0xFF3B82F6);
    final torsoRect = RRect.fromRectAndCorners(
      Rect.fromCenter(
        center: Offset(centerX, 98),
        width: 44,
        height: 48,
      ),
      topLeft: const Radius.circular(10),
      topRight: const Radius.circular(10),
      bottomLeft: const Radius.circular(4),
      bottomRight: const Radius.circular(4),
    );
    canvas.drawRRect(torsoRect, torsoPaint);

    // Small collar detail
    final collarPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(centerX, 74), width: 14, height: 10),
      0,
      math.pi,
      false,
      collarPaint,
    );

    // ── 4. Neck ─────────────────────────────────────────────────────────────
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(centerX, 70), width: 12, height: 10),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFFDE047),
    );

    // ── 5. Head (Warm Yellow Face) ──────────────────────────────────────────
    final headCenter = Offset(centerX, 50);
    const headRadius = 18.0;
    canvas.drawCircle(
      headCenter,
      headRadius,
      Paint()..color = const Color(0xFFFDE047),
    );

    // ── 6. Hair (Dark Curved Top) ───────────────────────────────────────────
    final hairPaint = Paint()..color = const Color(0xFF1E293B);
    final hairPath = Path()
      ..addArc(
        Rect.fromCircle(center: headCenter, radius: headRadius + 0.5),
        math.pi * 0.95,
        math.pi * 1.1,
      )
      ..close();
    canvas.drawPath(hairPath, hairPaint);

    // Bangs curve
    final bangsPath = Path()
      ..moveTo(headCenter.dx - headRadius, headCenter.dy - 3)
      ..quadraticBezierTo(
        headCenter.dx,
        headCenter.dy + 3,
        headCenter.dx + headRadius,
        headCenter.dy - 3,
      )
      ..lineTo(headCenter.dx + headRadius, headCenter.dy - headRadius)
      ..lineTo(headCenter.dx - headRadius, headCenter.dy - headRadius)
      ..close();
    canvas.drawPath(bangsPath, hairPaint);

    // ── 7. Face Features (Closed Happy Smiling Eyes & Smile) ────────────────
    final eyePaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // Left eye (upward curve ^)
    canvas.drawArc(
      Rect.fromCenter(center: Offset(centerX - 6, 50), width: 6, height: 5),
      math.pi * 1.1,
      math.pi * 0.8,
      false,
      eyePaint,
    );

    // Right eye (upward curve ^)
    canvas.drawArc(
      Rect.fromCenter(center: Offset(centerX + 6, 50), width: 6, height: 5),
      math.pi * 1.1,
      math.pi * 0.8,
      false,
      eyePaint,
    );

    // Cheerful smile
    final smilePaint = Paint()
      ..color = const Color(0xFFEF4444)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCenter(center: Offset(centerX, 55), width: 9, height: 6),
      0,
      math.pi,
      false,
      smilePaint,
    );

    // Cute blush cheeks
    final blushPaint = Paint()..color = const Color(0xFFFB7185).withValues(alpha: 0.35);
    canvas.drawCircle(Offset(centerX - 10, 55), 2.5, blushPaint);
    canvas.drawCircle(Offset(centerX + 10, 55), 2.5, blushPaint);
  }

  /// Helper to draw a 4-pointed star
  void _drawStar(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()..color = color;
    final path = Path();
    const int points = 4;
    final double innerRadius = radius * 0.4;

    for (int i = 0; i < points * 2; i++) {
      final double r = i.isEven ? radius : innerRadius;
      final double angle = (i * math.pi) / points - (math.pi / 2);
      final double x = center.dx + r * math.cos(angle);
      final double y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  /// Helper to draw a rotated rectangle confetti particle
  void _drawRotatedRect(
    Canvas canvas,
    Offset center,
    Size rectSize,
    double radians,
    Color color,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(radians);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: rectSize.width,
          height: rectSize.height,
        ),
        const Radius.circular(1.5),
      ),
      Paint()..color = color,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
