import 'dart:convert';

import 'package:flutter/services.dart';

import 'models.dart';
import 'practice_question_generator.dart';

class EmsileRepository {
  const EmsileRepository._();

  static Future<AppData> load() async {
    final rawJson = await rootBundle.loadString('assets/data/emsile_seed.json');
    final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
    final seedData = AppData.fromJson(decoded);
    return seedData.copyWith(
      practiceQuestions: PracticeQuestionGenerator.fromForms(seedData.forms),
    );
  }
}
