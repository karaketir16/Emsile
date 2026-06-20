class PracticeQuestion {
  const PracticeQuestion({
    required this.prompt,
    required this.arabic,
    required this.options,
    required this.answer,
    required this.explanation,
  });

  final String prompt;
  final String arabic;
  final List<String> options;
  final String answer;
  final String explanation;

  factory PracticeQuestion.fromJson(Map<String, dynamic> json) {
    return PracticeQuestion(
      prompt: json['prompt'] as String,
      arabic: json['arabic'] as String,
      options: (json['options'] as List<dynamic>).cast<String>(),
      answer: json['answer'] as String,
      explanation: json['explanation'] as String,
    );
  }
}
