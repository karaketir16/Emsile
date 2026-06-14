import 'models.dart';

class CatalogData {
  const CatalogData({
    required this.version,
    required this.defaultVerbId,
    required this.lessons,
    required this.verbs,
  });

  final int version;
  final String defaultVerbId;
  final List<Lesson> lessons;
  final List<VerbManifest> verbs;

  factory CatalogData.fromJson(Map<String, dynamic> json) {
    return CatalogData(
      version: json['version'] as int,
      defaultVerbId: json['defaultVerbId'] as String,
      lessons: (json['lessons'] as List<dynamic>)
          .map((item) => Lesson.fromJson(item as Map<String, dynamic>))
          .toList(),
      verbs: (json['verbs'] as List<dynamic>)
          .map((item) => VerbManifest.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class VerbManifest {
  const VerbManifest({
    required this.id,
    required this.root,
    required this.title,
    required this.assetPath,
    required this.group,
  });

  final String id;
  final String root;
  final String title;
  final String assetPath;
  final String group;

  factory VerbManifest.fromJson(Map<String, dynamic> json) {
    return VerbManifest(
      id: json['id'] as String,
      root: json['root'] as String,
      title: json['title'] as String,
      assetPath: json['assetPath'] as String,
      group: json['group'] as String,
    );
  }
}

class VerbEntry {
  const VerbEntry({
    required this.meta,
    required this.muhtelifeEntries,
    required this.muttarideForms,
  });

  final VerbMeta meta;
  final List<MuhtelifeEntry> muhtelifeEntries;
  final List<ConjugationForm> muttarideForms;

  factory VerbEntry.fromJson(Map<String, dynamic> json) {
    return VerbEntry(
      meta: VerbMeta.fromJson(json['meta'] as Map<String, dynamic>),
      muhtelifeEntries: (json['muhtelifeEntries'] as List<dynamic>)
          .map((item) => MuhtelifeEntry.fromJson(item as Map<String, dynamic>))
          .toList(),
      muttarideForms: (json['muttarideForms'] as List<dynamic>)
          .map((item) => ConjugationForm.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class VerbMeta {
  const VerbMeta({
    required this.id,
    required this.root,
    required this.letters,
    required this.title,
    required this.transliteration,
    required this.meaningSummary,
    required this.group,
  });

  final String id;
  final String root;
  final List<String> letters;
  final String title;
  final String transliteration;
  final String meaningSummary;
  final String group;

  factory VerbMeta.fromJson(Map<String, dynamic> json) {
    return VerbMeta(
      id: json['id'] as String,
      root: json['root'] as String,
      letters: (json['letters'] as List<dynamic>).cast<String>(),
      title: json['title'] as String,
      transliteration: json['transliteration'] as String,
      meaningSummary: json['meaningSummary'] as String,
      group: json['group'] as String,
    );
  }
}

class MuhtelifeEntry {
  const MuhtelifeEntry({
    required this.type,
    required this.label,
    required this.arabic,
    required this.meaning,
    required this.sortOrder,
  });

  final String type;
  final String label;
  final String arabic;
  final String meaning;
  final int sortOrder;

  factory MuhtelifeEntry.fromJson(Map<String, dynamic> json) {
    return MuhtelifeEntry(
      type: json['type'] as String,
      label: json['label'] as String,
      arabic: json['arabic'] as String,
      meaning: json['meaning'] as String,
      sortOrder: json['sortOrder'] as int,
    );
  }
}
