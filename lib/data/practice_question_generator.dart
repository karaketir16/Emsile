import 'models.dart';

class PracticeQuestionGenerator {
  const PracticeQuestionGenerator._();

  static List<PracticeQuestion> fromForms(List<ConjugationForm> forms) {
    final questions = <PracticeQuestion>[];

    for (final form in forms) {
      final siblings = forms
          .where(
            (candidate) =>
                candidate.category == form.category &&
                candidate.voice == form.voice &&
                candidate != form,
          )
          .toList();

      questions.add(
        PracticeQuestion(
          prompt: 'Bu formun anlamı hangisi?',
          arabic: form.arabic,
          options: _buildMeaningOptions(form, siblings),
          answer: form.meaning,
          explanation:
              '${form.arabic} ${form.category.name} ${form.voice.name} ${form.pronounLabel.toLowerCase()} formudur.',
        ),
      );

      questions.add(
        PracticeQuestion(
          prompt: 'Bu form hangi şahsa aittir?',
          arabic: form.arabic,
          options: _buildPronounOptions(form, siblings),
          answer: form.pronounLabel,
          explanation:
              '${form.arabic} ${form.pronounLabel.toLowerCase()} için kullanılır.',
        ),
      );
    }

    return questions;
  }

  static List<String> _buildMeaningOptions(
    ConjugationForm form,
    List<ConjugationForm> siblings,
  ) {
    final options = <String>[form.meaning];

    for (final candidate in siblings) {
      if (!options.contains(candidate.meaning)) {
        options.add(candidate.meaning);
      }
      if (options.length == 4) {
        break;
      }
    }

    return options;
  }

  static List<String> _buildPronounOptions(
    ConjugationForm form,
    List<ConjugationForm> siblings,
  ) {
    final options = <String>[form.pronounLabel];

    for (final candidate in siblings) {
      if (!options.contains(candidate.pronounLabel)) {
        options.add(candidate.pronounLabel);
      }
      if (options.length == 4) {
        break;
      }
    }

    return options;
  }
}
