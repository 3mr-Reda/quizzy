import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/category_model.dart';
import '../widgets/flutter_icon_badge.dart';
import 'quiz_in_progress_screen.dart';

typedef CategoryDetails = CategoryDetailsScreen;

class CategoryDetailsScreen extends StatelessWidget {
  final QuizCategory category;

  const CategoryDetailsScreen({
    super.key,
    this.category = const QuizCategory(
      id: 'flutter',
      title: 'Flutter',
      quizCount: 10,
      questionsCount: 10,
      durationMinutes: 15,
      description:
          'This quiz covers the basics of Flutter, including widgets, state management, and more.',
      color: Color(0xFF0284C7),
      isFlutterLogo: true,
    ),
  });

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                // 1. Top Navigation Bar (Back Arrow)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFF1E293B),
                          size: 24,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                        tooltip: 'Back',
                      ),
                    ],
                  ),
                ),

                // 2. Scrollable Body Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Header Card (Soft lavender/blue card)
                        _buildHeroCard(),

                        const SizedBox(height: 24),

                        // Section 1: About this quiz
                        Text(
                          'About this quiz',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.description.isNotEmpty
                              ? category.description
                              : 'This quiz covers the basics of ${category.cleanTitle}, including core concepts, practical questions, and more.',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF64748B),
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Section 2: Instructions
                        Text(
                          'Instructions',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 14),

                        _buildInstructionItem(
                          number: '1',
                          text: 'Choose the correct answer from 4 options.',
                        ),
                        const SizedBox(height: 12),
                        _buildInstructionItem(
                          number: '2',
                          text: "You can't change your answer after submission.",
                        ),
                        const SizedBox(height: 12),
                        _buildInstructionItem(
                          number: '3',
                          text: 'Complete all questions before time runs out.',
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // 3. Bottom Action Button (Start Quiz)
                _buildBottomButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFEFF5FF),
            Color(0xFFE8EEFE),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF506DF2).withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      child: Column(
        children: [
          // Category Icon Badge
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: category.color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: category.color.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: category.isFlutterLogo
                ? const FlutterWhiteLogo(size: 32)
                : Icon(
                    category.iconData,
                    color: Colors.white,
                    size: 34,
                  ),
          ),
          const SizedBox(height: 16),

          // Category Title
          Text(
            category.cleanTitle,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle
          Text(
            'Test your ${category.cleanTitle} knowledge!',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF7585A2),
            ),
          ),
          const SizedBox(height: 18),

          // Info Badges (Pills)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: [
              _buildInfoPill(
                icon: Icons.schedule_rounded,
                label: '${category.questionsCount} Questions',
              ),
              _buildInfoPill(
                icon: Icons.calendar_today_outlined,
                label: '${category.durationMinutes} Minutes',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPill({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: const Color(0xFF506DF2),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem({
    required String number,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: Color(0xFFF1F5F9),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF475569),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QuizInProgressScreen(category: category),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5961E8),
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: const Color(0xFF5961E8).withValues(alpha: 0.45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Start Quiz',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // iOS Home Indicator
          Container(
            width: 135,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFD1D5DB),
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
        ],
      ),
    );
  }
}
