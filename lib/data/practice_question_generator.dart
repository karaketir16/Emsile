import 'dart:math';
import 'models.dart';

class PracticeQuestionGenerator {
  const PracticeQuestionGenerator._();

  static PracticeQuestion generateSingleQuestion(
    List<ConjugationForm> forms, [
    Random? randomOverride,
  ]) {
    if (forms.isEmpty) {
      throw StateError('Forms list cannot be empty.');
    }

    final random = randomOverride ?? Random();
    final form = forms[random.nextInt(forms.length)];
    final direction = _QuestionDirection.values[random.nextInt(2)];
    return _buildQuestion(form, forms, direction, random);
  }

  static List<PracticeQuestion> fromForms(List<ConjugationForm> forms) {
    final random = Random();
    return [
      for (final form in forms)
        _buildQuestion(form, forms, _QuestionDirection.arabicToMeaning, random),
    ];
  }

  static PracticeQuestion _buildQuestion(
    ConjugationForm form,
    List<ConjugationForm> forms,
    _QuestionDirection direction,
    Random random,
  ) {
    final distractors =
        forms.where((candidate) => candidate.arabic != form.arabic).toList()
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
