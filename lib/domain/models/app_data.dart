import 'conjugation_form.dart';
import 'content.dart';
import 'practice_question.dart';

class AppData {
  const AppData({
    required this.lessons,
    required this.pronouns,
    required this.muhtelifeEntries,
    required this.forms,
    required this.practiceQuestions,
  });

  final List<Lesson> lessons;
  final List<PronounEntry> pronouns;
  final List<MuhtelifeEntry> muhtelifeEntries;
  final List<ConjugationForm> forms;
  final List<PracticeQuestion> practiceQuestions;

  factory AppData.fromJson(Map<String, dynamic> json) {
    return AppData(
      lessons: (json['lessons'] as List<dynamic>)
          .map((item) => Lesson.fromJson(item as Map<String, dynamic>))
          .toList(),
      pronouns: ((json['pronouns'] as List<dynamic>?) ?? [])
          .map((item) => PronounEntry.fromJson(item as Map<String, dynamic>))
          .toList(),
      muhtelifeEntries: ((json['muhtelifeEntries'] as List<dynamic>?) ?? [])
          .map((item) => MuhtelifeEntry.fromJson(item as Map<String, dynamic>))
          .toList(),
      forms: (json['forms'] as List<dynamic>)
          .map((item) => ConjugationForm.fromJson(item as Map<String, dynamic>))
          .toList(),
      practiceQuestions: ((json['practiceQuestions'] as List<dynamic>?) ?? [])
          .map(
            (item) => PracticeQuestion.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  AppData copyWith({
    List<Lesson>? lessons,
    List<PronounEntry>? pronouns,
    List<MuhtelifeEntry>? muhtelifeEntries,
    List<ConjugationForm>? forms,
    List<PracticeQuestion>? practiceQuestions,
  }) {
    return AppData(
      lessons: lessons ?? this.lessons,
      pronouns: pronouns ?? this.pronouns,
      muhtelifeEntries: muhtelifeEntries ?? this.muhtelifeEntries,
      forms: forms ?? this.forms,
      practiceQuestions: practiceQuestions ?? this.practiceQuestions,
    );
  }
}
