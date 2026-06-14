import 'package:emsile_flutter/data/models.dart';
import 'package:emsile_flutter/shared/widgets/app_page.dart';
import 'package:emsile_flutter/shared/widgets/arabic_result_card.dart';
import 'package:emsile_flutter/shared/widgets/info_panel.dart';
import 'package:flutter/material.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({required this.data, super.key});

  final AppData data;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Dersler',
      subtitle: 'PDF akışını mobil çalışma başlıklarına böldük.',
      child: Column(
        children: data.lessons
            .map(
              (lesson) => LessonTile(
                lesson: lesson,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          LessonDetailScreen(lesson: lesson, data: data),
                    ),
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class LessonDetailScreen extends StatelessWidget {
  const LessonDetailScreen({
    required this.lesson,
    required this.data,
    super.key,
  });

  final Lesson lesson;
  final AppData data;

  @override
  Widget build(BuildContext context) {
    final muhtelifeRows = _buildMuhtelifeRows(data.muhtelifeEntries);
    final relatedForms = data.forms
        .where((form) => form.category == lesson.relatedCategory)
        .take(4)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: AppPage(
          title: lesson.title,
          subtitle: lesson.summary,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Geri',
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoPanel(title: 'Kural Notu', body: lesson.rule),
              const SizedBox(height: 16),
              if (lesson.title == 'Emsile-i Muhtelife') ...[
                Text(
                  'Muhtelife Tablosu',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                _MuhtelifeTable(rows: muhtelifeRows),
              ] else ...[
                Text('Örnekler', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                for (final form in relatedForms) ...[
                  ArabicResultCard(form: form),
                  const SizedBox(height: 10),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

List<_MuhtelifeRow> _buildMuhtelifeRows(List<MuhtelifeEntry> entries) {
  final rows = <int, _MuhtelifeRowBuilder>{};

  for (final entry in entries) {
    if (entry.row == null || entry.column == null) {
      continue;
    }
    final builder = rows.putIfAbsent(
      entry.row!,
      () => _MuhtelifeRowBuilder(entry.row!),
    );
    if (entry.column == 'left') {
      builder.left = entry;
    } else if (entry.column == 'right') {
      builder.right = entry;
    }
  }

  final orderedKeys = rows.keys.toList()..sort();
  return orderedKeys
      .map(
        (key) => _MuhtelifeRow(left: rows[key]!.left, right: rows[key]!.right),
      )
      .toList();
}

class _MuhtelifeTable extends StatelessWidget {
  const _MuhtelifeTable({required this.rows});

  final List<_MuhtelifeRow> rows;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Table(
        columnWidths: const {0: FlexColumnWidth(), 1: FlexColumnWidth()},
        border: TableBorder.symmetric(
          inside: BorderSide(color: Theme.of(context).dividerColor),
        ),
        children: [
          for (final row in rows)
            TableRow(
              children: [
                _MuhtelifeCell(entry: row.left, alignEnd: false),
                _MuhtelifeCell(entry: row.right, alignEnd: true),
              ],
            ),
        ],
      ),
    );
  }
}

class _MuhtelifeCell extends StatelessWidget {
  const _MuhtelifeCell({required this.entry, required this.alignEnd});

  final MuhtelifeEntry? entry;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    if (entry == null) {
      return const SizedBox.shrink();
    }

    final textAlign = alignEnd ? TextAlign.end : TextAlign.start;
    final crossAxisAlignment = alignEnd
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            entry!.label,
            textAlign: textAlign,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              entry!.arabic,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 6),
          Text(entry!.meaning, textAlign: textAlign),
        ],
      ),
    );
  }
}

class _MuhtelifeRowBuilder {
  _MuhtelifeRowBuilder(this.row);

  final int row;
  MuhtelifeEntry? left;
  MuhtelifeEntry? right;
}

class _MuhtelifeRow {
  const _MuhtelifeRow({required this.left, required this.right});

  final MuhtelifeEntry? left;
  final MuhtelifeEntry? right;
}

class LessonTile extends StatelessWidget {
  const LessonTile({required this.lesson, required this.onTap, super.key});

  final Lesson lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(lesson.order.toString()),
        ),
        title: Text(
          lesson.title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(lesson.summary),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
