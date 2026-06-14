import 'catalog_models.dart';
import 'models.dart';

class MuttarideGenerator {
  const MuttarideGenerator._();

  static List<ConjugationForm> fromVerbEntry(VerbEntry entry) {
    if (entry.muttarideForms.isNotEmpty) {
      return entry.muttarideForms;
    }

    final source = entry.conjugationSource;
    if (source == null) {
      throw StateError(
        'Verb entry must define muttarideForms or conjugationSource.',
      );
    }

    switch (source.strategy) {
      case 'generated':
        final generated = source.generated;
        if (generated == null) {
          throw StateError(
            'Generated conjugation source is missing its config.',
          );
        }
        return _generate(entry.meta, generated);
      default:
        throw UnsupportedError(
          'Unsupported conjugation strategy: ${source.strategy}',
        );
    }
  }

  static List<ConjugationForm> _generate(
    VerbMeta meta,
    GeneratedConjugationSource config,
  ) {
    if (config.family != 'sulasi_mujarrad' ||
        config.verbClass != 'sahih_salim' ||
        config.bab != 'nasara_yansuru') {
      throw UnsupportedError(
        'Unsupported generated profile: ${config.family}/${config.verbClass}/${config.bab}',
      );
    }

    final forms = <ConjugationForm>[];

    for (final slot in _slots) {
      forms.add(
        ConjugationForm(
          category: FormCategory.mazi,
          voice: Voice.malum,
          person: slot.person,
          number: slot.number,
          gender: slot.gender,
          pronounLabel: slot.pronounLabel,
          arabic: _maziMalum(meta.letters, slot),
          meaning: '${slot.subjectPhrase} yardim etti.',
        ),
      );

      forms.add(
        ConjugationForm(
          category: FormCategory.mazi,
          voice: Voice.mechul,
          person: slot.person,
          number: slot.number,
          gender: slot.gender,
          pronounLabel: slot.pronounLabel,
          arabic: _maziMechul(meta.letters, slot),
          meaning: '${slot.objectPhrase} icin yardim edildi.',
        ),
      );

      forms.add(
        ConjugationForm(
          category: FormCategory.muzari,
          voice: Voice.malum,
          person: slot.person,
          number: slot.number,
          gender: slot.gender,
          pronounLabel: slot.pronounLabel,
          arabic: _muzariMalum(meta.letters, slot),
          meaning: '${slot.subjectPhrase} yardim ediyor.',
        ),
      );

      forms.add(
        ConjugationForm(
          category: FormCategory.muzari,
          voice: Voice.mechul,
          person: slot.person,
          number: slot.number,
          gender: slot.gender,
          pronounLabel: slot.pronounLabel,
          arabic: _muzariMechul(meta.letters, slot),
          meaning: '${slot.objectPhrase} icin yardim ediliyor.',
        ),
      );
    }

    return forms;
  }

  static String _maziMalum(List<String> letters, _Slot slot) {
    return '${letters[0]}َ${letters[1]}َ${letters[2]}${slot.maziSuffixMalum}';
  }

  static String _maziMechul(List<String> letters, _Slot slot) {
    return '${letters[0]}ُ${letters[1]}ِ${letters[2]}${slot.maziSuffixMechul}';
  }

  static String _muzariMalum(List<String> letters, _Slot slot) {
    return '${slot.muzariPrefixMalum}${letters[0]}ْ${letters[1]}ُ${letters[2]}${slot.muzariSuffixMalum}';
  }

  static String _muzariMechul(List<String> letters, _Slot slot) {
    return '${slot.muzariPrefixMechul}${letters[0]}ْ${letters[1]}َ${letters[2]}${slot.muzariSuffixMechul}';
  }
}

class _Slot {
  const _Slot({
    required this.person,
    required this.number,
    required this.gender,
    required this.pronounLabel,
    required this.subjectPhrase,
    required this.objectPhrase,
    required this.maziSuffixMalum,
    required this.maziSuffixMechul,
    required this.muzariPrefixMalum,
    required this.muzariPrefixMechul,
    required this.muzariSuffixMalum,
    required this.muzariSuffixMechul,
  });

  final FormPerson person;
  final FormNumber number;
  final FormGender gender;
  final String pronounLabel;
  final String subjectPhrase;
  final String objectPhrase;
  final String maziSuffixMalum;
  final String maziSuffixMechul;
  final String muzariPrefixMalum;
  final String muzariPrefixMechul;
  final String muzariSuffixMalum;
  final String muzariSuffixMechul;
}

const _slots = <_Slot>[
  _Slot(
    person: FormPerson.third,
    number: FormNumber.singular,
    gender: FormGender.masculine,
    pronounLabel: 'O (er.)',
    subjectPhrase: 'O erkek',
    objectPhrase: 'O erkek',
    maziSuffixMalum: 'َ',
    maziSuffixMechul: 'َ',
    muzariPrefixMalum: 'يَ',
    muzariPrefixMechul: 'يُ',
    muzariSuffixMalum: 'ُ',
    muzariSuffixMechul: 'ُ',
  ),
  _Slot(
    person: FormPerson.third,
    number: FormNumber.dual,
    gender: FormGender.masculine,
    pronounLabel: 'O ikisi (er.)',
    subjectPhrase: 'O iki erkek',
    objectPhrase: 'O iki erkek',
    maziSuffixMalum: 'َا',
    maziSuffixMechul: 'َا',
    muzariPrefixMalum: 'يَ',
    muzariPrefixMechul: 'يُ',
    muzariSuffixMalum: 'َانِ',
    muzariSuffixMechul: 'َانِ',
  ),
  _Slot(
    person: FormPerson.third,
    number: FormNumber.plural,
    gender: FormGender.masculine,
    pronounLabel: 'Onlar (er.)',
    subjectPhrase: 'O erkekler',
    objectPhrase: 'O erkekler',
    maziSuffixMalum: 'ُوا',
    maziSuffixMechul: 'ُوا',
    muzariPrefixMalum: 'يَ',
    muzariPrefixMechul: 'يُ',
    muzariSuffixMalum: 'ُونَ',
    muzariSuffixMechul: 'ُونَ',
  ),
  _Slot(
    person: FormPerson.third,
    number: FormNumber.singular,
    gender: FormGender.feminine,
    pronounLabel: 'O (kad.)',
    subjectPhrase: 'O kadin',
    objectPhrase: 'O kadin',
    maziSuffixMalum: 'َتْ',
    maziSuffixMechul: 'َتْ',
    muzariPrefixMalum: 'تَ',
    muzariPrefixMechul: 'تُ',
    muzariSuffixMalum: 'ُ',
    muzariSuffixMechul: 'ُ',
  ),
  _Slot(
    person: FormPerson.third,
    number: FormNumber.dual,
    gender: FormGender.feminine,
    pronounLabel: 'O ikisi (kad.)',
    subjectPhrase: 'O iki kadin',
    objectPhrase: 'O iki kadin',
    maziSuffixMalum: 'َتَا',
    maziSuffixMechul: 'َتَا',
    muzariPrefixMalum: 'تَ',
    muzariPrefixMechul: 'تُ',
    muzariSuffixMalum: 'َانِ',
    muzariSuffixMechul: 'َانِ',
  ),
  _Slot(
    person: FormPerson.third,
    number: FormNumber.plural,
    gender: FormGender.feminine,
    pronounLabel: 'Onlar (kad.)',
    subjectPhrase: 'O kadinlar',
    objectPhrase: 'O kadinlar',
    maziSuffixMalum: 'ْنَ',
    maziSuffixMechul: 'ْنَ',
    muzariPrefixMalum: 'يَ',
    muzariPrefixMechul: 'يُ',
    muzariSuffixMalum: 'ْنَ',
    muzariSuffixMechul: 'ْنَ',
  ),
  _Slot(
    person: FormPerson.second,
    number: FormNumber.singular,
    gender: FormGender.masculine,
    pronounLabel: 'Sen (er.)',
    subjectPhrase: 'Sen erkek',
    objectPhrase: 'Sen erkek',
    maziSuffixMalum: 'ْتَ',
    maziSuffixMechul: 'ْتَ',
    muzariPrefixMalum: 'تَ',
    muzariPrefixMechul: 'تُ',
    muzariSuffixMalum: 'ُ',
    muzariSuffixMechul: 'ُ',
  ),
  _Slot(
    person: FormPerson.second,
    number: FormNumber.dual,
    gender: FormGender.masculine,
    pronounLabel: 'Siz ikiniz (er.)',
    subjectPhrase: 'Siz iki erkek',
    objectPhrase: 'Siz iki erkek',
    maziSuffixMalum: 'ْتُمَا',
    maziSuffixMechul: 'ْتُمَا',
    muzariPrefixMalum: 'تَ',
    muzariPrefixMechul: 'تُ',
    muzariSuffixMalum: 'َانِ',
    muzariSuffixMechul: 'َانِ',
  ),
  _Slot(
    person: FormPerson.second,
    number: FormNumber.plural,
    gender: FormGender.masculine,
    pronounLabel: 'Siz (er.)',
    subjectPhrase: 'Siz erkekler',
    objectPhrase: 'Siz erkekler',
    maziSuffixMalum: 'ْتُمْ',
    maziSuffixMechul: 'ْتُمْ',
    muzariPrefixMalum: 'تَ',
    muzariPrefixMechul: 'تُ',
    muzariSuffixMalum: 'ُونَ',
    muzariSuffixMechul: 'ُونَ',
  ),
  _Slot(
    person: FormPerson.second,
    number: FormNumber.singular,
    gender: FormGender.feminine,
    pronounLabel: 'Sen (kad.)',
    subjectPhrase: 'Sen kadin',
    objectPhrase: 'Sen kadin',
    maziSuffixMalum: 'ْتِ',
    maziSuffixMechul: 'ْتِ',
    muzariPrefixMalum: 'تَ',
    muzariPrefixMechul: 'تُ',
    muzariSuffixMalum: 'ِينَ',
    muzariSuffixMechul: 'ِينَ',
  ),
  _Slot(
    person: FormPerson.second,
    number: FormNumber.dual,
    gender: FormGender.feminine,
    pronounLabel: 'Siz ikiniz (kad.)',
    subjectPhrase: 'Siz iki kadin',
    objectPhrase: 'Siz iki kadin',
    maziSuffixMalum: 'ْتُمَا',
    maziSuffixMechul: 'ْتُمَا',
    muzariPrefixMalum: 'تَ',
    muzariPrefixMechul: 'تُ',
    muzariSuffixMalum: 'َانِ',
    muzariSuffixMechul: 'َانِ',
  ),
  _Slot(
    person: FormPerson.second,
    number: FormNumber.plural,
    gender: FormGender.feminine,
    pronounLabel: 'Siz (kad.)',
    subjectPhrase: 'Siz kadinlar',
    objectPhrase: 'Siz kadinlar',
    maziSuffixMalum: 'ْتُنَّ',
    maziSuffixMechul: 'ْتُنَّ',
    muzariPrefixMalum: 'تَ',
    muzariPrefixMechul: 'تُ',
    muzariSuffixMalum: 'ْنَ',
    muzariSuffixMechul: 'ْنَ',
  ),
  _Slot(
    person: FormPerson.first,
    number: FormNumber.singular,
    gender: FormGender.common,
    pronounLabel: 'Ben',
    subjectPhrase: 'Ben',
    objectPhrase: 'Ben',
    maziSuffixMalum: 'ْتُ',
    maziSuffixMechul: 'ْتُ',
    muzariPrefixMalum: 'أَ',
    muzariPrefixMechul: 'أُ',
    muzariSuffixMalum: 'ُ',
    muzariSuffixMechul: 'ُ',
  ),
  _Slot(
    person: FormPerson.first,
    number: FormNumber.plural,
    gender: FormGender.common,
    pronounLabel: 'Biz',
    subjectPhrase: 'Biz',
    objectPhrase: 'Biz',
    maziSuffixMalum: 'ْنَا',
    maziSuffixMechul: 'ْنَا',
    muzariPrefixMalum: 'نَ',
    muzariPrefixMechul: 'نُ',
    muzariSuffixMalum: 'ُ',
    muzariSuffixMechul: 'ُ',
  ),
];
