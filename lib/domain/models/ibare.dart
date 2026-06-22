enum IbareField {
  structure('structure', 'Yapısı'),
  wordForm('wordForm', 'Kelime biçimi'),
  root('root', 'Kök'),
  singular('singular', 'Tekili'),
  derivedFrom('derivedFrom', 'Türediği fiil'),
  baseForm('baseForm', 'Aslı'),
  bab('bab', 'Bab'),
  pattern('pattern', 'Vezin'),
  morphology('morphology', 'Türü'),
  conjugation('conjugation', 'Çekim'),
  person('person', 'Şahıs'),
  hiddenPronoun('hiddenPronoun', 'Gizli zamir'),
  pronoun('pronoun', 'Zamir'),
  referent('referent', 'Mercii'),
  transitivity('transitivity', 'Geçişlilik'),
  presentForm('presentForm', 'Muzârisi'),
  middleRadical('middleRadical', 'Aynü’l-fiil'),
  numberType('numberType', 'Sayı türü'),
  tamyiz('tamyiz', 'Temyizi'),
  meaning('meaning', 'Anlam'),
  turkish('turkish', 'Türkçesi'),
  term('term', 'Terim'),
  effect('effect', 'Etkisi'),
  syntax('syntax', 'Cümledeki görev'),
  role('role', 'Görevi'),
  construction('construction', 'Tamlama'),
  noun('noun', 'İsim'),
  nasb('nasb', 'Nasb'),
  irab('irab', 'İ‘rab'),
  ellipsis('ellipsis', 'Takdir');

  const IbareField(this.key, this.label);

  final String key;
  final String label;

  static IbareField fromJson(String key) => values.firstWhere(
    (field) => field.key == key,
    orElse: () => throw FormatException('Bilinmeyen ibare alanı: $key'),
  );
}

class IbareDetail {
  const IbareDetail({required this.label, required this.value});

  final String label;
  final String value;

  factory IbareDetail.fromJson(Map<String, dynamic> json) => IbareDetail(
    label: json['label'] as String,
    value: json['value'] as String,
  );
}

class IbareToken {
  const IbareToken({
    required this.id,
    required this.arabic,
    required this.gloss,
    required this.kind,
    required this.fields,
    required this.details,
    this.printedArabic,
    this.punctuation = '',
  });

  final String id;
  final String arabic;
  final String? printedArabic;
  final String punctuation;
  final String gloss;
  final String kind;
  final Map<IbareField, String> fields;
  final List<IbareDetail> details;

  bool get hasOptionalHarakat =>
      printedArabic != null && printedArabic != arabic;

  String displayArabic(bool showHarakat) =>
      '${showHarakat ? arabic : printedArabic ?? arabic}$punctuation';

  factory IbareToken.fromJson(Map<String, dynamic> json) {
    final analysis =
        (json['analysis'] as Map<String, dynamic>?) ??
        const <String, dynamic>{};
    final fieldsJson =
        (analysis['fields'] as Map<String, dynamic>?) ??
        const <String, dynamic>{};

    return IbareToken(
      id: json['id'] as String,
      arabic: json['arabic'] as String,
      printedArabic: json['printedArabic'] as String?,
      punctuation: (json['punctuation'] as String?) ?? '',
      gloss: json['gloss'] as String,
      kind: analysis['kind'] as String,
      fields: {
        for (final entry in fieldsJson.entries)
          IbareField.fromJson(entry.key): entry.value as String,
      },
      details: ((analysis['details'] as List<dynamic>?) ?? const [])
          .map((item) => IbareDetail.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class IbarePassage {
  const IbarePassage({
    required this.id,
    required this.order,
    required this.title,
    required this.subtitle,
    required this.translation,
    required this.tokens,
  });

  final String id;
  final int order;
  final String title;
  final String subtitle;
  final String translation;
  final List<IbareToken> tokens;

  bool get hasOptionalHarakat =>
      tokens.any((token) => token.hasOptionalHarakat);

  factory IbarePassage.fromJson(Map<String, dynamic> json) => IbarePassage(
    id: json['id'] as String,
    order: json['order'] as int,
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    translation: json['translation'] as String,
    tokens: (json['tokens'] as List<dynamic>)
        .map((item) => IbareToken.fromJson(item as Map<String, dynamic>))
        .toList(),
  );
}

class IbareBook {
  const IbareBook({
    required this.schemaVersion,
    required this.id,
    required this.title,
    required this.shortTitle,
    required this.description,
    required this.passages,
  });

  final int schemaVersion;
  final String id;
  final String title;
  final String shortTitle;
  final String description;
  final List<IbarePassage> passages;

  factory IbareBook.fromJson(Map<String, dynamic> json) {
    final schemaVersion = json['schemaVersion'] as int;
    if (schemaVersion != 1) {
      throw FormatException('Desteklenmeyen ibare şema sürümü: $schemaVersion');
    }

    final passages =
        (json['passages'] as List<dynamic>)
            .map((item) => IbarePassage.fromJson(item as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order));
    _requireUnique(
      passages.map((passage) => passage.id),
      'İbare pasaj kimlikleri',
    );
    for (final passage in passages) {
      _requireUnique(
        passage.tokens.map((token) => token.id),
        '${passage.id} token kimlikleri',
      );
    }

    return IbareBook(
      schemaVersion: schemaVersion,
      id: json['id'] as String,
      title: json['title'] as String,
      shortTitle: json['shortTitle'] as String,
      description: json['description'] as String,
      passages: passages,
    );
  }
}

void _requireUnique(Iterable<String> values, String field) {
  final seen = <String>{};
  for (final value in values) {
    if (!seen.add(value)) {
      throw FormatException('$field benzersiz olmalıdır: $value');
    }
  }
}
