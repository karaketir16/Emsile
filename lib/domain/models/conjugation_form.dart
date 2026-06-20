import 'grammar.dart';

class ConjugationForm {
  const ConjugationForm({
    required this.category,
    required this.voice,
    required this.person,
    required this.number,
    required this.gender,
    required this.pronounLabel,
    required this.arabic,
    required this.meaning,
  });

  final FormCategory category;
  final Voice voice;
  final FormPerson person;
  final FormNumber number;
  final FormGender gender;
  final String pronounLabel;
  final String arabic;
  final String meaning;

  bool get isBrokenPlural => pronounLabel.contains('Kırık');

  String get practiceGroup {
    if (!category.isNoun) {
      return pronounLabel;
    }
    if (isBrokenPlural) {
      return 'Kırık Çoğul';
    }
    if (number == FormNumber.plural) {
      return 'Çoğul (Kurallı)';
    }
    return number == FormNumber.dual ? 'İkil' : 'Tekil';
  }

  String get rule {
    final parts = category.isNoun
        ? <String>[
            if (gender != FormGender.common) gender.label,
            number.label,
            category.label,
          ]
        : <String>[
            person.label,
            number.label,
            if (gender != FormGender.common) gender.label,
            category.label,
            voice.label,
          ];
    return '${parts.join(' ')} formudur.';
  }

  factory ConjugationForm.fromJson(Map<String, dynamic> json) {
    return ConjugationForm(
      category: FormCategory.fromJson(json['category'] as String),
      voice: Voice.fromJson(json['voice'] as String),
      person: FormPerson.fromJson(json['person'] as String),
      number: FormNumber.fromJson(json['number'] as String),
      gender: FormGender.fromJson(json['gender'] as String),
      pronounLabel: json['pronounLabel'] as String,
      arabic: json['arabic'] as String,
      meaning: json['meaning'] as String,
    );
  }
}
