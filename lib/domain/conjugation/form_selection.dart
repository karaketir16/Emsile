import 'package:emsile_flutter/domain/models/conjugation_form.dart';
import 'package:emsile_flutter/domain/models/content.dart';
import 'package:emsile_flutter/domain/models/grammar.dart';

class FormSelection {
  const FormSelection({
    required this.person,
    required this.number,
    required this.gender,
    this.arabic,
  });

  factory FormSelection.fromForm(ConjugationForm form) {
    return FormSelection(
      person: form.person,
      number: form.number,
      gender: form.gender,
      arabic: form.arabic,
    );
  }

  final FormPerson person;
  final FormNumber number;
  final FormGender gender;
  final String? arabic;

  bool matches(ConjugationForm form) {
    return (arabic == null || form.arabic == arabic) &&
        form.person == person &&
        form.number == number &&
        form.gender == gender;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FormSelection &&
            other.person == person &&
            other.number == number &&
            other.gender == gender &&
            other.arabic == arabic;
  }

  @override
  int get hashCode => Object.hash(person, number, gender, arabic);
}

class ConjugationRowSpec {
  const ConjugationRowSpec({
    required this.person,
    required this.gender,
    required this.label,
  });

  final FormPerson person;
  final FormGender gender;
  final String label;

  FormSelection selectionFor(FormNumber number) {
    return FormSelection(person: person, number: number, gender: gender);
  }
}

class ConjugationColumnSpec {
  const ConjugationColumnSpec(this.number, this.label);

  final FormNumber number;
  final String label;
}

const conjugationColumns = [
  ConjugationColumnSpec(FormNumber.plural, 'Çoğul'),
  ConjugationColumnSpec(FormNumber.dual, 'İkil'),
  ConjugationColumnSpec(FormNumber.singular, 'Tekil'),
];

const conjugationRows = [
  ConjugationRowSpec(
    person: FormPerson.third,
    gender: FormGender.masculine,
    label: '3. Şahıs\nMüzekker',
  ),
  ConjugationRowSpec(
    person: FormPerson.third,
    gender: FormGender.feminine,
    label: '3. Şahıs\nMüennes',
  ),
  ConjugationRowSpec(
    person: FormPerson.second,
    gender: FormGender.masculine,
    label: '2. Şahıs\nMüzekker',
  ),
  ConjugationRowSpec(
    person: FormPerson.second,
    gender: FormGender.feminine,
    label: '2. Şahıs\nMüennes',
  ),
  ConjugationRowSpec(
    person: FormPerson.first,
    gender: FormGender.common,
    label: '1. Şahıs\nOrtak',
  ),
];

ConjugationForm? findConjugationForm(
  Iterable<ConjugationForm> forms,
  FormSelection selection,
) {
  for (final form in forms) {
    if (selection.matches(form)) {
      return form;
    }
  }

  if (selection.person == FormPerson.first &&
      selection.number == FormNumber.dual) {
    for (final form in forms) {
      if (form.person == FormPerson.first &&
          form.number == FormNumber.plural &&
          form.gender == selection.gender) {
        return form;
      }
    }
  }
  return null;
}

PronounEntry? findPronoun(
  Iterable<PronounEntry> pronouns,
  FormSelection selection,
) {
  for (final pronoun in pronouns) {
    if (pronoun.person == selection.person &&
        pronoun.number == selection.number &&
        pronoun.gender == selection.gender) {
      return pronoun;
    }
  }
  return null;
}
