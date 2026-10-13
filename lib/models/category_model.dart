import 'package:flutter/material.dart';

enum QuizDifficulty { easy, medium, hard }

extension QuizDifficultyExt on QuizDifficulty {
  String get label {
    switch (this) {
      case QuizDifficulty.easy:
        return 'Easy';
      case QuizDifficulty.medium:
        return 'Medium';
      case QuizDifficulty.hard:
        return 'Hard';
    }
  }

  Color get color {
    switch (this) {
      case QuizDifficulty.easy:
        return const Color(0xFF22C55E);
      case QuizDifficulty.medium:
        return const Color(0xFFF59E0B);
      case QuizDifficulty.hard:
        return const Color(0xFFEF4444);
    }
  }
}

class QuizCategory {
  final String id;
  final String title;
  final int quizCount;
  final int questionsCount;
  final int durationMinutes;
  final String description;
  final Color color;
  final IconData? iconData;
  final bool isFlutterLogo;
  final QuizDifficulty difficulty;

  const QuizCategory({
    required this.id,
    required this.title,
    this.quizCount = 10,
    this.questionsCount = 10,
    this.durationMinutes = 15,
    this.description = '',
    required this.color,
    this.iconData,
    this.isFlutterLogo = false,
    this.difficulty = QuizDifficulty.medium,
  });

  String get cleanTitle => title.replaceAll('\n', ' ');
}

final List<QuizCategory> defaultCategories = [
  const QuizCategory(
    id: 'flutter',
    title: 'Flutter',
    quizCount: 10,
    questionsCount: 10,
    durationMinutes: 15,
    description:
        'This quiz covers the basics of Flutter, including widgets, state management, and more.',
    color: Color(0xFF0284C7),
    isFlutterLogo: true,
    difficulty: QuizDifficulty.easy,
  ),
  const QuizCategory(
    id: 'dart',
    title: 'Dart',
    quizCount: 10,
    questionsCount: 10,
    durationMinutes: 15,
    description:
        'This quiz covers the basics of Dart, including syntax, OOP principles, and async programming.',
    color: Color(0xFF00BFA5),
    iconData: Icons.adjust_rounded,
    difficulty: QuizDifficulty.medium,
  ),
  const QuizCategory(
    id: 'general_knowledge',
    title: 'General\nKnowledge',
    quizCount: 10,
    questionsCount: 10,
    durationMinutes: 15,
    description:
        'Test your general knowledge across geography, history, inventions, and world cultures.',
    color: Color(0xFFFA8C16),
    iconData: Icons.psychology_outlined,
    difficulty: QuizDifficulty.easy,
  ),
  const QuizCategory(
    id: 'mathematics',
    title: 'Mathematics',
    quizCount: 10,
    questionsCount: 10,
    durationMinutes: 15,
    description:
        'Challenge your skills with algebra, arithmetic puzzles, geometry, and numerical logic.',
    color: Color(0xFFFF4066),
    iconData: Icons.calculate_outlined,
    difficulty: QuizDifficulty.medium,
  ),
  const QuizCategory(
    id: 'english',
    title: 'English',
    quizCount: 10,
    questionsCount: 10,
    durationMinutes: 15,
    description:
        'Test your English proficiency in grammar rules, vocabulary, idioms, and sentence structure.',
    color: Color(0xFF5961E8),
    iconData: Icons.menu_book_rounded,
    difficulty: QuizDifficulty.medium,
  ),
  const QuizCategory(
    id: 'science',
    title: 'Science',
    quizCount: 10,
    questionsCount: 10,
    durationMinutes: 15,
    description:
        'Explore core fundamentals of physics, chemistry, biology, and fascinating natural laws.',
    color: Color(0xFF22C55E),
    iconData: Icons.science_outlined,
    difficulty: QuizDifficulty.hard,
  ),
];
