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
    final muhtelifeEntries = _sortedMuhtelifeEntries(data.muhtelifeEntries);
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
                _MuhtelifeList(entries: muhtelifeEntries),
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

List<MuhtelifeEntry> _sortedMuhtelifeEntries(List<MuhtelifeEntry> entries) {
  final sorted = [...entries];
  sorted.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return sorted;
}

class _MuhtelifeList extends StatelessWidget {
  const _MuhtelifeList({required this.entries});

  final List<MuhtelifeEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < entries.length; index++) ...[
          _MuhtelifeListItem(index: index + 1, entry: entries[index]),
          if (index != entries.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _MuhtelifeListItem extends StatelessWidget {
  const _MuhtelifeListItem({required this.index, required this.entry});

  final int index;
  final MuhtelifeEntry entry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    index.toString(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.label,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.meaning,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                entry.arabic,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
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
