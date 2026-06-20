import 'dart:math';
import 'models.dart';

class PracticeQuestionGenerator {
  const PracticeQuestionGenerator._();

  static bool canGenerateQuestion(List<ConjugationForm> forms) {
    return _viableQuestions(forms).isNotEmpty;
  }

  static PracticeQuestion generateSingleQuestion(
    List<ConjugationForm> forms, [
    Random? randomOverride,
  ]) {
    if (forms.isEmpty) {
      throw StateError('Forms list cannot be empty.');
    }

    final random = randomOverride ?? Random();
    final viable = _viableQuestions(forms);
    if (viable.isEmpty) {
      throw StateError(
        'At least two unique forms from the same category are required.',
      );
    }
    final selected = viable[random.nextInt(viable.length)];
    return _buildQuestion(
      selected.form,
      selected.siblings,
      selected.direction,
      random,
    );
  }

  static List<PracticeQuestion> fromForms(List<ConjugationForm> forms) {
    final random = Random();
    return [
      for (final form in forms)
        if (_siblingsFor(form, forms).length >= 2)
          _buildQuestion(
            form,
            _siblingsFor(form, forms),
            _QuestionDirection.arabicToMeaning,
            random,
          ),
    ];
  }

  static PracticeQuestion _buildQuestion(
    ConjugationForm form,
    List<ConjugationForm> siblings,
    _QuestionDirection direction,
    Random random,
  ) {
    final distractors =
        siblings.where((candidate) => candidate.arabic != form.arabic).toList()
          ..shuffle(random);

    if (direction == _QuestionDirection.arabicToMeaning) {
      return PracticeQuestion(
        prompt: 'Bu sîganın anlamı hangisi?',
        arabic: form.arabic,
        options: _buildMeaningOptions(form, distractors, random),
        answer: form.meaning,
        explanation: '${form.arabic} ${form.rule}',
      );
    }
    return PracticeQuestion(
      prompt: 'Hangisi bu anlama gelir: "${form.meaning}"?',
      arabic: '؟',
      options: _buildArabicOptions(form, distractors, random),
      answer: form.arabic,
      explanation:
          '"${form.meaning}" ifadesinin Arapça karşılığı ${form.arabic}.',
    );
  }

  static List<_QuestionCandidate> _viableQuestions(
    List<ConjugationForm> forms,
  ) {
    final candidates = <_QuestionCandidate>[];
    for (final form in forms) {
      final siblings = _siblingsFor(form, forms);
      if (_uniqueCount(siblings, (item) => item.meaning) >= 2) {
        candidates.add(
          _QuestionCandidate(
            form: form,
            siblings: siblings,
            direction: _QuestionDirection.arabicToMeaning,
          ),
        );
      }
      if (_uniqueCount(siblings, (item) => item.arabic) >= 2) {
        candidates.add(
          _QuestionCandidate(
            form: form,
            siblings: siblings,
            direction: _QuestionDirection.meaningToArabic,
          ),
        );
      }
    }
    return candidates;
  }

  static List<ConjugationForm> _siblingsFor(
    ConjugationForm form,
    List<ConjugationForm> forms,
  ) {
    return forms
        .where((candidate) => candidate.category == form.category)
        .toList();
  }

  static int _uniqueCount(
    List<ConjugationForm> forms,
    String Function(ConjugationForm form) select,
  ) {
    return forms.map(select).toSet().length;
  }

  static List<String> _buildMeaningOptions(
    ConjugationForm form,
    List<ConjugationForm> siblings,
    Random random,
  ) {
    final options = <String>[form.meaning];

    for (final candidate in siblings) {
      if (!options.contains(candidate.meaning)) {
        options.add(candidate.meaning);
      }
      if (options.length == 5) {
        break;
      }
    }

    options.shuffle(random);
    return options;
  }

  static List<String> _buildArabicOptions(
    ConjugationForm form,
    List<ConjugationForm> siblings,
    Random random,
  ) {
    final options = <String>[form.arabic];

    for (final candidate in siblings) {
      if (!options.contains(candidate.arabic)) {
        options.add(candidate.arabic);
      }
      if (options.length == 5) {
        break;
      }
    }

    options.shuffle(random);
    return options;
  }
}

enum _QuestionDirection { arabicToMeaning, meaningToArabic }

class _QuestionCandidate {
  const _QuestionCandidate({
    required this.form,
    required this.siblings,
    required this.direction,
  });

  final ConjugationForm form;
  final List<ConjugationForm> siblings;
  final _QuestionDirection direction;
}
