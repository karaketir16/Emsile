import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:emsile_flutter/data/models.dart';
import 'package:emsile_flutter/data/practice_question_generator.dart';

void main() {
  group('PracticeQuestionGenerator', () {
    test('generates meaning questions for each form', () {
      final questions = PracticeQuestionGenerator.fromForms(testForms);

      expect(questions, hasLength(testForms.length));

      final meaningQuestion = questions.firstWhere(
        (question) =>
            question.prompt == 'Bu sîganın anlamı hangisi?' &&
            question.arabic == 'نَصَرَ',
      );
      expect(meaningQuestion.answer, 'O erkek yardım etti.');
      expect(meaningQuestion.options, contains('O erkek yardım etti.'));
      expect(meaningQuestion.options, contains('O iki erkek yardım etti.'));
    });

    test('does not generate pronoun questions', () {
      final questions = PracticeQuestionGenerator.fromForms(
        duplicatedArabicForms,
      );

      expect(
        questions,
        isNot(
          contains(
            isA<PracticeQuestion>().having(
              (question) => question.prompt,
              'prompt',
              contains('şahsa'),
            ),
          ),
        ),
      );
    });

    test('runtime questions use only two directions and unique options', () {
      final prompts = <String>{};

      for (var seed = 0; seed < 50; seed++) {
        final question = PracticeQuestionGenerator.generateSingleQuestion(
          testForms,
          Random(seed),
        );
        prompts.add(question.prompt);

        expect(question.options, contains(question.answer));
        expect(question.options.length, lessThanOrEqualTo(5));
        expect(question.options.toSet(), hasLength(question.options.length));
        expect(question.prompt, isNot(contains('şahsa')));
        expect(question.prompt, isNot(contains('dil bilgisi özelliği')));
      }

      expect(
        prompts.any((prompt) => prompt == 'Bu sîganın anlamı hangisi?'),
        isTrue,
      );
      expect(
        prompts.any((prompt) => prompt.startsWith('Hangisi bu anlama gelir:')),
        isTrue,
      );
    });

    test('arabic distractors exclude duplicate spellings', () {
      for (var seed = 0; seed < 100; seed++) {
        final question = PracticeQuestionGenerator.generateSingleQuestion(
          duplicatedArabicForms,
          Random(seed),
        );
        if (!question.prompt.startsWith('Hangisi bu anlama gelir:')) continue;

        expect(question.options.toSet(), hasLength(question.options.length));
      }
    });

    test('distractors stay in the target category', () {
      final forms = [
        ...testForms,
        const ConjugationForm(
          category: FormCategory.muzari,
          voice: Voice.malum,
          person: FormPerson.third,
          number: FormNumber.singular,
          gender: FormGender.masculine,
          pronounLabel: 'O (er.)',
          arabic: 'يَنْصُرُ',
          meaning: 'O (erkek) yardım ediyor.',
        ),
        const ConjugationForm(
          category: FormCategory.muzari,
          voice: Voice.mechul,
          person: FormPerson.third,
          number: FormNumber.singular,
          gender: FormGender.masculine,
          pronounLabel: 'O (er.)',
          arabic: 'يُنْصَرُ',
          meaning: 'Ona (erkek) yardım ediliyor.',
        ),
      ];

      for (var seed = 0; seed < 30; seed++) {
        final question = PracticeQuestionGenerator.generateSingleQuestion(
          forms,
          Random(seed),
        );
        final target = forms.firstWhere(
          (form) =>
              form.arabic == question.answer ||
              form.meaning == question.answer ||
              form.arabic == question.arabic,
        );
        final categoryValues = forms
            .where((form) => form.category == target.category)
            .expand((form) => [form.arabic, form.meaning])
            .toSet();

        expect(question.options, everyElement(isIn(categoryValues)));
      }
    });

    test('uses fewer than five options when category has fewer forms', () {
      final question = PracticeQuestionGenerator.generateSingleQuestion(
        testForms.take(3).toList(),
        Random(1),
      );

      expect(question.options, hasLength(3));
    });
  });
}

const testForms = [
  ConjugationForm(
    category: FormCategory.mazi,
    voice: Voice.malum,
    person: FormPerson.third,
    number: FormNumber.singular,
    gender: FormGender.masculine,
    pronounLabel: 'O (er.)',
    arabic: 'نَصَرَ',
    meaning: 'O erkek yardım etti.',
  ),
  ConjugationForm(
    category: FormCategory.mazi,
    voice: Voice.malum,
    person: FormPerson.third,
    number: FormNumber.dual,
    gender: FormGender.masculine,
    pronounLabel: 'O ikisi (er.)',
    arabic: 'نَصَرَا',
    meaning: 'O iki erkek yardım etti.',
  ),
  ConjugationForm(
    category: FormCategory.mazi,
    voice: Voice.malum,
    person: FormPerson.third,
    number: FormNumber.plural,
    gender: FormGender.masculine,
    pronounLabel: 'Onlar (er.)',
    arabic: 'نَصَرُوا',
    meaning: 'O erkekler yardım etti.',
  ),
  ConjugationForm(
    category: FormCategory.mazi,
    voice: Voice.malum,
    person: FormPerson.third,
    number: FormNumber.singular,
    gender: FormGender.feminine,
    pronounLabel: 'O (kad.)',
    arabic: 'نَصَرَتْ',
    meaning: 'O kadın yardım etti.',
  ),
];

const duplicatedArabicForms = [
  ConjugationForm(
    category: FormCategory.muzari,
    voice: Voice.mechul,
    person: FormPerson.third,
    number: FormNumber.plural,
    gender: FormGender.masculine,
    pronounLabel: 'Onlar (er.)',
    arabic: 'يُنْصَرْنَ',
    meaning: 'Onlara yardım edilir.',
  ),
  ConjugationForm(
    category: FormCategory.muzari,
    voice: Voice.mechul,
    person: FormPerson.third,
    number: FormNumber.singular,
    gender: FormGender.feminine,
    pronounLabel: 'O (kad.)',
    arabic: 'يُنْصَرْنَ',
    meaning: 'O kadına yardım edilir.',
  ),
  ConjugationForm(
    category: FormCategory.muzari,
    voice: Voice.mechul,
    person: FormPerson.second,
    number: FormNumber.plural,
    gender: FormGender.feminine,
    pronounLabel: 'Siz (kad.)',
    arabic: 'تُنْصَرْنَ',
    meaning: 'Size yardım edilir.',
  ),
  ConjugationForm(
    category: FormCategory.muzari,
    voice: Voice.mechul,
    person: FormPerson.third,
    number: FormNumber.plural,
    gender: FormGender.feminine,
    pronounLabel: 'Onlar (kad.)',
    arabic: 'يُنْصَرْنَ',
    meaning: 'O kadınlara yardım edilir.',
  ),
];
