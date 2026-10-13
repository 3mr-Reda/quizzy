import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/quiz_questions_data.dart';
import '../models/category_model.dart';
import '../models/question_model.dart';
import 'final_screen.dart';

// Aliases for seamless backwards-compatibility across the app
typedef QuizScreen = QuizInProgressScreen;
typedef Quiz = QuizInProgressScreen;

/// Quiz in Progress Screen
///
/// Features:
/// - Question counter (e.g. 5/10)
/// - Timer pill (e.g. 00:32)
/// - Support for syntax-highlighted code snippet cards
/// - Green selected option card with custom radio dot and checkmark badge
/// - Clean unselected cards with subtle border and radio outline
/// - Full-width bottom "Next →" action button
class QuizInProgressScreen extends StatefulWidget {
  final QuizCategory category;

  const QuizInProgressScreen({
    super.key,
    this.category = const QuizCategory(
      id: 'flutter',
      title: 'Flutter',
      color: Color(0xFF0284C7),
      isFlutterLogo: true,
    ),
  });

  @override
  State<QuizInProgressScreen> createState() => _QuizInProgressScreenState();
}

class _QuizInProgressScreenState extends State<QuizInProgressScreen> {
  late List<QuizQuestion> _questions;
  late List<int?> _userAnswers;
  int _currentIndex = 0;
  int? _selectedOptionIndex;
  int _score = 0;

  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Load fresh, randomized questions for this category
    _questions = getRandomQuestionsForCategory(widget.category.id, count: 10);
    _userAnswers = List<int?>.filled(_questions.length, null);
    // 90 seconds total countdown
    _remainingSeconds = 90;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        if (mounted) {
          setState(() {
            _remainingSeconds--;
          });
        }
      } else {
        _timer?.cancel();
        _onTimeUp();
      }
    });
  }

  void _onTimeUp() {
    if (!mounted) return;
    _navigateToResult();
  }

  void _navigateToResult() {
    _timer?.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => FinalScreen(
          category: widget.category,
          score: _score,
          totalQuestions: _questions.length,
          questions: _questions,
          userAnswers: _userAnswers,
          isTimeUp: _remainingSeconds <= 0,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _onOptionSelected(int index) {
    setState(() {
      _selectedOptionIndex = index;
    });
  }

  void _onNextPressed() {
    if (_selectedOptionIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select an answer to proceed',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Record user answer
    _userAnswers[_currentIndex] = _selectedOptionIndex;

    // Check if chosen answer is correct
    if (_selectedOptionIndex == _questions[_currentIndex].correctIndex) {
      _score++;
    }

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null;
      });
    } else {
      _navigateToResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentIndex];
    final bool isLastQuestion = _currentIndex == _questions.length - 1;

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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // 1. Top Header: Progress (e.g. 5/10) + Timer Pill (e.g. 00:32)
                  _buildHeader(),

                  const SizedBox(height: 24),

                  // 2. Middle Content (Scrollable for zero overflow on any device)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Question Title
                          Text(
                            currentQuestion.question,
                            style: GoogleFonts.poppins(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                              height: 1.35,
                            ),
                          ),

                          // Code Snippet Card (if present)
                          if (currentQuestion.codeSnippet != null &&
                              currentQuestion.codeSnippet!.trim().isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _buildCodeBlock(currentQuestion.codeSnippet!),
                          ],

                          const SizedBox(height: 20),

                          // Options List
                          ...List.generate(
                            currentQuestion.options.length,
                            (index) {
                              final optionText = currentQuestion.options[index];
                              final bool isSelected =
                                  _selectedOptionIndex == index;
                              return _buildOptionCard(
                                index: index,
                                text: optionText,
                                isSelected: isSelected,
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),

                  // 3. Bottom Button: Next / Submit Quiz + Home Bar
                  _buildBottomButton(isLastQuestion),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Top Progress and Timer Pill
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Question Progress (e.g. 5/10)
        Text(
          '${_currentIndex + 1}/${_questions.length}',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),

        // Timer Capsule (e.g. 00:32)
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF1FE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 15,
                color: Color(0xFF5961E8),
              ),
              const SizedBox(width: 6),
              Text(
                _formatTime(_remainingSeconds),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF5961E8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Syntax-highlighted code block container
  Widget _buildCodeBlock(String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2235), // Dark navy slate
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E2235).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SelectableText.rich(
        TextSpan(
          children: _highlightCode(code),
          style: GoogleFonts.jetBrainsMono(
            fontSize: 13.5,
            height: 1.6,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Tokenizer and syntax highlighter for Dart code snippets
  List<TextSpan> _highlightCode(String code) {
    final List<TextSpan> spans = [];

    final regex = RegExp(
      r'(//[^\n]*)|' // 1: Comments
      r'("(?:\\.|[^"\\])*"|' r"'(?:\\.|[^'\\])*')|" // 2: Strings
      r'(\b(?:void|var|final|const|int|double|String|bool|dynamic|return|class|import|export|if|else|for|while|switch|case|default|async|await|yield|true|false|null|new|this|super|extends|with|implements|static|late)\b)|' // 3: Keywords
      r'(\b\d+(?:\.\d+)?\b)|' // 4: Numbers
      r'(\b[a-zA-Z_][a-zA-Z0-9_]*(?=\s*\())|' // 5: Function calls / definitions
      r'([{}()\[\];,+\-*/%=<>!&|^~?:]+)|' // 6: Symbols & operators
      r'([a-zA-Z_][a-zA-Z0-9_]*)|' // 7: Identifiers
      r'(\s+)', // 8: Whitespace
    );

    int lastIndex = 0;
    for (final match in regex.allMatches(code)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: code.substring(lastIndex, match.start),
          style: const TextStyle(color: Color(0xFFE2E8F0)),
        ));
      }

      final matchedText = match.group(0)!;
      Color color;

      if (match.group(1) != null) {
        // Comment
        color = const Color(0xFF64748B);
      } else if (match.group(2) != null) {
        // String
        color = const Color(0xFF34D399);
      } else if (match.group(3) != null) {
        // Keyword (void, main, etc.)
        color = const Color(0xFF818CF8);
      } else if (match.group(4) != null) {
        // Number (1, 2, 3)
        color = const Color(0xFFFB923C);
      } else if (match.group(5) != null) {
        // Function call / definition (main, print)
        color = const Color(0xFF38BDF8);
      } else if (match.group(6) != null) {
        // Symbols & operators
        color = const Color(0xFFF1F5F9);
      } else {
        color = const Color(0xFFE2E8F0);
      }

      spans.add(TextSpan(
        text: matchedText,
        style: TextStyle(color: color),
      ));
      lastIndex = match.end;
    }

    if (lastIndex < code.length) {
      spans.add(TextSpan(
        text: code.substring(lastIndex),
        style: const TextStyle(color: Color(0xFFE2E8F0)),
      ));
    }

    return spans;
  }

  /// Option Card with custom radio button and checkmark badge
  Widget _buildOptionCard({
    required int index,
    required String text,
    required bool isSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: InkWell(
        onTap: () => _onOptionSelected(index),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF22C55E) // Vibrant green border when selected
                  : const Color(0xFFE2E8F0), // Subtle slate border
              width: isSelected ? 1.6 : 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            children: [
              // Radio Indicator
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected
                    ? const Color(0xFF22C55E)
                    : const Color(0xFFCBD5E1),
                size: 22,
              ),
              const SizedBox(width: 14),

              // Option Text
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF1E293B)
                        : const Color(0xFF334155),
                  ),
                ),
              ),

              // Right Checkmark Icon (only displayed when selected)
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF22C55E),
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Bottom Next / Submit Button + iOS Home Indicator
  Widget _buildBottomButton(bool isLastQuestion) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _onNextPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5961E8),
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: const Color(0xFF5961E8).withValues(alpha: 0.35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLastQuestion ? 'Submit Quiz' : 'Next',
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
        const SizedBox(height: 8),
      ],
    );
  }
}
