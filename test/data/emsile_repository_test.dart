import 'dart:convert';

import 'package:emsile_flutter/data/emsile_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('repository composes catalog and generated verb data', () async {
    final repository = EmsileRepository(
      bundle: _MapAssetBundle({
        'assets/data/catalog.json': jsonEncode({
          'version': 1,
          'defaultVerbId': 'nasara',
          'lessons': <Object>[],
          'pronouns': <Object>[],
          'ibareBooks': [
            {
              'id': 'bina',
              'title': 'Binâ',
              'assetPath': 'assets/data/ibare/bina.json',
            },
          ],
          'verbs': [
            {
              'id': 'nasara',
              'root': 'نصر',
              'title': 'نصر',
              'assetPath': 'assets/data/verbs/nasara.json',
              'group': 'sulasi_mujarrad',
            },
          ],
        }),
        'assets/data/verbs/nasara.json': jsonEncode({
          'meta': {
            'id': 'nasara',
            'root': 'نصر',
            'letters': ['ن', 'ص', 'ر'],
            'title': 'نصر',
            'transliteration': 'nasara',
            'meaningSummary': 'yardım etmek',
            'group': 'sulasi_mujarrad',
          },
          'muhtelifeEntries': <Object>[],
          'conjugationSource': {
            'strategy': 'generated',
            'generated': {
              'family': 'sulasi_mujarrad',
              'verbClass': 'sahih_salim',
              'bab': 'nasara_yansuru',
              'lemma': {'mazi': 'نَصَرَ', 'muzari': 'يَنْصُرُ'},
            },
          },
        }),
        'assets/data/ibare/bina.json': jsonEncode({
          'schemaVersion': 1,
          'id': 'bina',
          'title': 'Binâ',
          'shortTitle': 'Binâ',
          'description': 'İbare çalışması',
          'passages': [
            {
              'id': 'giris',
              'order': 1,
              'title': 'Giriş',
              'subtitle': 'İlk cümle',
              'translation': 'Bil.',
              'tokens': [
                {
                  'id': 'giris_1',
                  'arabic': 'اِعْلَمْ',
                  'printedArabic': 'اعلم',
                  'gloss': 'Bil',
                  'analysis': {
                    'kind': 'Fiil',
                    'fields': {'conjugation': 'Emr-i hâzır'},
                  },
                },
              ],
            },
          ],
        }),
      }),
    );

    final data = await repository.load();

    expect(data.forms, hasLength(339));
    expect(data.practiceQuestions, hasLength(339));
    expect(data.ibareBooks.single.passages.single.tokens.single.gloss, 'Bil');
  });

  test('repository reports a missing default verb manifest', () async {
    final repository = EmsileRepository(
      bundle: _MapAssetBundle({
        'assets/data/catalog.json': jsonEncode({
          'version': 1,
          'defaultVerbId': 'missing',
          'lessons': <Object>[],
          'pronouns': <Object>[],
          'verbs': <Object>[],
        }),
      }),
    );

    expect(repository.load(), throwsStateError);
  });
}

class _MapAssetBundle extends CachingAssetBundle {
  _MapAssetBundle(this.assets);

  final Map<String, String> assets;

  @override
  Future<ByteData> load(String key) async {
    final value = assets[key];
    if (value == null) {
      throw StateError('Asset not found: $key');
    }
    return ByteData.sublistView(Uint8List.fromList(utf8.encode(value)));
  }
}
