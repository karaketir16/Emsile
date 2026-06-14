import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:emsile_flutter/data/catalog_models.dart';
import 'package:emsile_flutter/data/models.dart';
import 'package:emsile_flutter/data/muttaride_generator.dart';

void main() {
  group('MuttarideGenerator', () {
    test('generates 56 forms for nasara generated source', () {
      final entry = VerbEntry.fromJson(
        jsonDecode(nasaraVerbJson) as Map<String, dynamic>,
      );

      final forms = MuttarideGenerator.fromVerbEntry(entry);

      expect(forms, hasLength(56));
    });

    test('generates key nasara forms correctly', () {
      final entry = VerbEntry.fromJson(
        jsonDecode(nasaraVerbJson) as Map<String, dynamic>,
      );

      final forms = MuttarideGenerator.fromVerbEntry(entry);

      expect(
        forms.any(
          (form) =>
              form.category == FormCategory.mazi &&
              form.voice == Voice.malum &&
              form.person == FormPerson.third &&
              form.number == FormNumber.singular &&
              form.gender == FormGender.masculine &&
              form.arabic == 'نَصَرَ',
        ),
        isTrue,
      );

      expect(
        forms.any(
          (form) =>
              form.category == FormCategory.mazi &&
              form.voice == Voice.mechul &&
              form.person == FormPerson.second &&
              form.number == FormNumber.singular &&
              form.gender == FormGender.masculine &&
              form.arabic == 'نُصِرْتَ',
        ),
        isTrue,
      );

      expect(
        forms.any(
          (form) =>
              form.category == FormCategory.muzari &&
              form.voice == Voice.malum &&
              form.person == FormPerson.second &&
              form.number == FormNumber.plural &&
              form.gender == FormGender.masculine &&
              form.arabic == 'تَنْصُرُونَ',
        ),
        isTrue,
      );

      expect(
        forms.any(
          (form) =>
              form.category == FormCategory.muzari &&
              form.voice == Voice.mechul &&
              form.person == FormPerson.first &&
              form.number == FormNumber.plural &&
              form.gender == FormGender.common &&
              form.arabic == 'نُنْصَرُ',
        ),
        isTrue,
      );
    });
  });
}

const nasaraVerbJson = '''
{
  "meta": {
    "id": "nasara",
    "root": "نصر",
    "letters": ["ن", "ص", "ر"],
    "title": "نصر",
    "transliteration": "nasara",
    "meaningSummary": "yardım etmek",
    "group": "sulasi_mujarrad"
  },
  "muhtelifeEntries": [
    {
      "type": "fiil_mazi",
      "label": "Fiil-i Mâzi",
      "arabic": "نَصَرَ",
      "meaning": "Yardım etti.",
      "sortOrder": 10
    }
  ],
  "conjugationSource": {
    "strategy": "generated",
    "generated": {
      "family": "sulasi_mujarrad",
      "verbClass": "sahih_salim",
      "bab": "nasara_yansuru",
      "lemma": {
        "mazi": "نَصَرَ",
        "muzari": "يَنْصُرُ"
      }
    }
  }
}
''';
