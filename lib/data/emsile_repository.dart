import 'dart:convert';

import 'package:flutter/services.dart';

import 'catalog_models.dart';
import 'models.dart';
import 'muttaride_generator.dart';
import 'practice_question_generator.dart';

class EmsileRepository {
  const EmsileRepository._();

  static Future<AppData> load() async {
    final catalogRaw = await rootBundle.loadString('assets/data/catalog.json');
    final catalogJson = jsonDecode(catalogRaw) as Map<String, dynamic>;
    final catalog = CatalogData.fromJson(catalogJson);

    final manifest = catalog.verbs.firstWhere(
      (verb) => verb.id == catalog.defaultVerbId,
    );
    final verbRaw = await rootBundle.loadString(manifest.assetPath);
    final verbJson = jsonDecode(verbRaw) as Map<String, dynamic>;
    final verbEntry = VerbEntry.fromJson(verbJson);
    final forms = MuttarideGenerator.fromVerbEntry(verbEntry);

    final seedData = AppData(
      lessons: catalog.lessons,
      muhtelifeEntries: verbEntry.muhtelifeEntries,
      forms: forms,
      practiceQuestions: const [],
    );

    return seedData.copyWith(
      practiceQuestions: PracticeQuestionGenerator.fromForms(forms),
    );
  }
}
