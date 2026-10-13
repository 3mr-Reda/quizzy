class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? codeSnippet;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.codeSnippet,
  });

  /// Returns a new question with shuffled options while keeping correct answer accurate
  QuizQuestion shuffled() {
    final correctAnswer = options[correctIndex];
    final shuffledOptions = List<String>.from(options)..shuffle();
    final newCorrectIndex = shuffledOptions.indexOf(correctAnswer);
    return QuizQuestion(
      question: question,
      options: shuffledOptions,
      correctIndex: newCorrectIndex,
      codeSnippet: codeSnippet,
    );
  }
}
