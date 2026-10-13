import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/question_model.dart';
import 'home_screen.dart';
import 'quiz_in_progress_screen.dart';

class ReviewAnswersScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  final List<int?> userAnswers;
  final QuizCategory category;
  final int score;

  const ReviewAnswersScreen({
    super.key,
    required this.questions,
    required this.userAnswers,
    required this.category,
    required this.score,
  });

  @override
  State<ReviewAnswersScreen> createState() => _ReviewAnswersScreenState();
}

class _ReviewAnswersScreenState extends State<ReviewAnswersScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Filter: 'all', 'correct', 'wrong'
  String _filter = 'all';
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  List<int> get _filteredIndices {
    final all = List<int>.generate(widget.questions.length, (i) => i);
    if (_filter == 'correct') {
      return all.where((i) {
        final ua = widget.userAnswers[i];
        return ua != null && ua == widget.questions[i].correctIndex;
      }).toList();
    } else if (_filter == 'wrong') {
      return all.where((i) {
        final ua = widget.userAnswers[i];
        return ua == null || ua != widget.questions[i].correctIndex;
      }).toList();
    }
    return all;
  }

  int get _correctCount {
    int c = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      final ua = widget.userAnswers[i];
      if (ua != null && ua == widget.questions[i].correctIndex) c++;
    }
    return c;
  }

  int get _wrongCount => widget.questions.length - _correctCount;

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

    final indices = _filteredIndices;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  // ── Header ──────────────────────────────────────────────
                  _buildHeader(context),

                  // ── Summary Stats Bar ────────────────────────────────────
                  _buildSummaryBar(),

                  // ── Filter Tabs ──────────────────────────────────────────
                  _buildFilterTabs(),

                  // ── Question List ────────────────────────────────────────
                  Expanded(
                    child: indices.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            physics: const BouncingScrollPhysics(),
                            itemCount: indices.length,
                            itemBuilder: (context, listIdx) {
                              final qIdx = indices[listIdx];
                              return _buildQuestionCard(qIdx, listIdx);
                            },
                          ),
                  ),

                  // ── Bottom Buttons ───────────────────────────────────────
                  _buildBottomButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Header
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 4),
      child: Row(
        children: [
          // Back button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Color(0xFF334155),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Review Answers',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                Text(
                  widget.category.cleanTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          // Score badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5961E8), Color(0xFF7C3AED)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5961E8).withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              '${widget.score}/${widget.questions.length}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Summary Bar
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildSummaryBar() {
    final total = widget.questions.length;
    final correctRatio = total > 0 ? _correctCount / total : 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                _statChip(
                  icon: Icons.check_circle_rounded,
                  color: const Color(0xFF22C55E),
                  label: 'Correct',
                  count: _correctCount,
                ),
                const SizedBox(width: 10),
                _statChip(
                  icon: Icons.cancel_rounded,
                  color: const Color(0xFFEF4444),
                  label: 'Wrong',
                  count: _wrongCount,
                ),
                const SizedBox(width: 10),
                _statChip(
                  icon: Icons.quiz_rounded,
                  color: const Color(0xFF5961E8),
                  label: 'Total',
                  count: total,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: correctRatio,
                backgroundColor: const Color(0xFFFEE2E2),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF22C55E),
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(correctRatio * 100).round()}% correct',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF22C55E),
                  ),
                ),
                Text(
                  '${widget.questions.length} questions',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip({
    required IconData icon,
    required Color color,
    required String label,
    required int count,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              '$count',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: color.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Filter Tabs
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFEEF2FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _filterTab('all', 'All'),
            _filterTab('correct', 'Correct'),
            _filterTab('wrong', 'Wrong'),
          ],
        ),
      ),
    );
  }

  Widget _filterTab(String value, String label) {
    final isActive = _filter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _filter = value;
            _expandedIndex = null;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive
                  ? const Color(0xFF5961E8)
                  : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Question Card
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildQuestionCard(int qIdx, int listIdx) {
    final question = widget.questions[qIdx];
    final userAnswer = widget.userAnswers[qIdx];
    final correctIdx = question.correctIndex;
    final isCorrect =
        userAnswer != null && userAnswer == correctIdx;
    final isSkipped = userAnswer == null;
    final isExpanded = _expandedIndex == qIdx;

    // Status color & icon
    Color statusColor;
    IconData statusIcon;
    String statusLabel;
    if (isSkipped) {
      statusColor = const Color(0xFFF59E0B);
      statusIcon = Icons.remove_circle_rounded;
      statusLabel = 'Skipped';
    } else if (isCorrect) {
      statusColor = const Color(0xFF22C55E);
      statusIcon = Icons.check_circle_rounded;
      statusLabel = 'Correct';
    } else {
      statusColor = const Color(0xFFEF4444);
      statusIcon = Icons.cancel_rounded;
      statusLabel = 'Wrong';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _expandedIndex = isExpanded ? null : qIdx;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isExpanded
                  ? statusColor.withValues(alpha: 0.4)
                  : const Color(0xFFE2E8F0),
              width: isExpanded ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isExpanded
                    ? statusColor.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: isExpanded ? 16 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Card Header ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Q number badge
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${listIdx + 1}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        question.question,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                          height: 1.4,
                        ),
                        maxLines: isExpanded ? null : 2,
                        overflow:
                            isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 13, color: statusColor),
                          const SizedBox(width: 3),
                          Text(
                            statusLabel,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Expanded: Answer Options ────────────────────────────
              if (isExpanded) ...[
                const Divider(
                  height: 1,
                  color: Color(0xFFF1F5F9),
                  indent: 14,
                  endIndent: 14,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (question.codeSnippet != null &&
                          question.codeSnippet!.trim().isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E2235),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            question.codeSnippet!,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              color: const Color(0xFFE2E8F0),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                      ...List.generate(question.options.length, (optIdx) {
                        final isCorrectOpt = optIdx == correctIdx;
                        final isUserOpt = userAnswer == optIdx;
                        return _buildOptionRow(
                          text: question.options[optIdx],
                          isCorrect: isCorrectOpt,
                          isUserSelected: isUserOpt,
                          isSkipped: isSkipped,
                        );
                      }),
                      if (isSkipped) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              size: 14,
                              color: Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'You did not answer this question.',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: const Color(0xFFF59E0B),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ] else ...[
                // Collapsed: just show chevron hint
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, right: 14),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Tap to expand',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: Color(0xFF94A3B8),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionRow({
    required String text,
    required bool isCorrect,
    required bool isUserSelected,
    required bool isSkipped,
  }) {
    // Determine the visual state
    Color bgColor;
    Color borderColor;
    Color textColor;
    Color? iconColor;
    IconData? icon;

    if (isCorrect) {
      bgColor = const Color(0xFFDCFCE7);
      borderColor = const Color(0xFF22C55E);
      textColor = const Color(0xFF15803D);
      icon = Icons.check_circle_rounded;
      iconColor = const Color(0xFF22C55E);
    } else if (isUserSelected && !isSkipped) {
      // User picked wrong
      bgColor = const Color(0xFFFEE2E2);
      borderColor = const Color(0xFFEF4444);
      textColor = const Color(0xFFB91C1C);
      icon = Icons.cancel_rounded;
      iconColor = const Color(0xFFEF4444);
    } else {
      bgColor = const Color(0xFFF8FAFF);
      borderColor = const Color(0xFFE2E8F0);
      textColor = const Color(0xFF475569);
      icon = null;
      iconColor = null;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 1.0),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 8),
            ] else ...[
              const SizedBox(width: 24),
            ],
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight:
                      isCorrect || isUserSelected ? FontWeight.w600 : FontWeight.w400,
                  color: textColor,
                ),
              ),
            ),
            if (isUserSelected && !isCorrect && !isSkipped)
              Text(
                'Your answer',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: const Color(0xFFEF4444),
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Empty State
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _filter == 'correct'
                ? Icons.sentiment_very_satisfied_rounded
                : Icons.sentiment_satisfied_alt_rounded,
            size: 60,
            color: const Color(0xFFCBD5E1),
          ),
          const SizedBox(height: 12),
          Text(
            _filter == 'correct'
                ? 'No correct answers yet!'
                : 'No wrong answers – great job!',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: const Color(0xFF94A3B8),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Bottom Buttons
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Retake Quiz
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => QuizInProgressScreen(category: widget.category),
                  ),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                'Retake Quiz',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5961E8),
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: const Color(0xFF5961E8).withValues(alpha: 0.35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Go Home
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.home_rounded, size: 18),
              label: Text(
                'Go Home',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF475569),
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF475569),
                side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // iOS home indicator
          Container(
            width: 135,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFD1D5DB),
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
