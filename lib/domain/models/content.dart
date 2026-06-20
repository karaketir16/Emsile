import 'grammar.dart';

class PronounEntry {
  const PronounEntry({
    required this.kind,
    required this.person,
    required this.number,
    required this.gender,
    required this.labelTr,
    required this.arabic,
    required this.meaning,
  });

  final PronounKind kind;
  final FormPerson person;
  final FormNumber number;
  final FormGender gender;
  final String labelTr;
  final String arabic;
  final String meaning;

  factory PronounEntry.fromJson(Map<String, dynamic> json) {
    return PronounEntry(
      kind: PronounKind.fromJson(json['kind'] as String),
      person: FormPerson.fromJson(json['person'] as String),
      number: FormNumber.fromJson(json['number'] as String),
      gender: FormGender.fromJson(json['gender'] as String),
      labelTr: json['labelTr'] as String,
      arabic: json['arabic'] as String,
      meaning: json['meaning'] as String,
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
    this.row,
    this.column,
  });

  final String type;
  final String label;
  final String arabic;
  final String meaning;
  final int sortOrder;
  final int? row;
  final String? column;

  factory MuhtelifeEntry.fromJson(Map<String, dynamic> json) {
    return MuhtelifeEntry(
      type: json['type'] as String,
      label: json['label'] as String,
      arabic: json['arabic'] as String,
      meaning: json['meaning'] as String,
      sortOrder: json['sortOrder'] as int,
      row: json['row'] as int?,
      column: json['column'] as String?,
    );
  }
}

class Lesson {
  const Lesson({
    required this.order,
    required this.title,
    required this.summary,
    required this.rule,
    required this.relatedCategory,
  });

  final int order;
  final String title;
  final String summary;
  final String rule;
  final FormCategory relatedCategory;

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      order: json['order'] as int,
      title: json['title'] as String,
      summary: json['summary'] as String,
      rule: json['rule'] as String,
      relatedCategory: FormCategory.fromJson(json['relatedCategory'] as String),
    );
  }
}
