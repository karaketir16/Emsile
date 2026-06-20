import 'package:emsile_flutter/data/models.dart';
import 'package:flutter/material.dart';

const verbPracticeGroups = [
  'O (er.)',
  'O ikisi (er.)',
  'Onlar (er.)',
  'O (kad.)',
  'O ikisi (kad.)',
  'Onlar (kad.)',
  'Sen (er.)',
  'Siz ikiniz (er.)',
  'Siz (er.)',
  'Sen (kad.)',
  'Siz ikiniz (kad.)',
  'Siz (kad.)',
  'Ben',
  'Biz',
];

const nounPracticeGroups = ['Tekil', 'İkil', 'Çoğul (Kurallı)', 'Kırık Çoğul'];

class PracticeFilters extends StatelessWidget {
  const PracticeFilters({
    required this.availableForms,
    required this.categories,
    required this.voices,
    required this.groups,
    required this.onCategoriesChanged,
    required this.onVoicesChanged,
    required this.onGroupsChanged,
    super.key,
  });

  final List<ConjugationForm> availableForms;
  final Set<FormCategory> categories;
  final Set<Voice> voices;
  final Set<String> groups;
  final ValueChanged<Set<FormCategory>> onCategoriesChanged;
  final ValueChanged<Set<Voice>> onVoicesChanged;
  final ValueChanged<Set<String>> onGroupsChanged;

  bool get _showVerbs => categories.isEmpty
      ? availableForms.any((form) => form.category.isVerb)
      : categories.any((category) => category.isVerb);

  bool get _showNouns => categories.isEmpty
      ? availableForms.any((form) => form.category.isNoun)
      : categories.any((category) => category.isNoun);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Çekim Tabloları',
          onSelectAll: () => onCategoriesChanged(FormCategory.values.toSet()),
          onClearAll: () => onCategoriesChanged({}),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 8.0;
            final width = (constraints.maxWidth - spacing) / 2;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final category in FormCategory.values)
                  SizedBox(
                    width: width,
                    child: _CategoryOption(
                      category: category,
                      selected: categories.contains(category),
                      onTap: () =>
                          onCategoriesChanged(_toggled(categories, category)),
                    ),
                  ),
              ],
            );
          },
        ),
        if (_showVerbs) ...[
          const SizedBox(height: 20),
          _VoiceFilters(selected: voices, onChanged: onVoicesChanged),
          const SizedBox(height: 20),
          _PronounFilters(selected: groups, onChanged: onGroupsChanged),
        ],
        if (_showNouns) ...[
          const SizedBox(height: 20),
          _NounFilters(selected: groups, onChanged: onGroupsChanged),
        ],
      ],
    );
  }
}

class _VoiceFilters extends StatelessWidget {
  const _VoiceFilters({required this.selected, required this.onChanged});

  final Set<Voice> selected;
  final ValueChanged<Set<Voice>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionHeader(
          title: 'Çatı (Malum/Meçhul)',
          onSelectAll: () => onChanged(Voice.values.toSet()),
          onClearAll: () => onChanged({}),
        ),
        _FilterTable(
          child: Table(
            border: const TableBorder(
              verticalInside: BorderSide(color: Color(0xFFD8D1C1)),
            ),
            children: [
              TableRow(
                children: [
                  for (final voice in Voice.values)
                    _SelectableCell(
                      text: voice.label,
                      selected: selected.contains(voice),
                      onTap: () => onChanged(_toggled(selected, voice)),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PronounFilters extends StatelessWidget {
  const _PronounFilters({required this.selected, required this.onChanged});

  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  void _toggleGroup(List<String> values) {
    final next = {...selected};
    values.every(next.contains) ? next.removeAll(values) : next.addAll(values);
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionHeader(
          title: 'Şahıslar (Fiiller)',
          onSelectAll: () => onChanged({...selected, ...verbPracticeGroups}),
          onClearAll: () =>
              onChanged({...selected}..removeAll(verbPracticeGroups)),
        ),
        _FilterTable(
          child: Table(
            border: const TableBorder(
              horizontalInside: BorderSide(color: Color(0xFFD8D1C1)),
              verticalInside: BorderSide(color: Color(0xFFD8D1C1)),
            ),
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
              3: FixedColumnWidth(96),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  _HeaderCell(
                    text: 'Çoğul',
                    onTap: () => _toggleGroup(const [
                      'Onlar (er.)',
                      'Onlar (kad.)',
                      'Siz (er.)',
                      'Siz (kad.)',
                      'Biz',
                    ]),
                  ),
                  _HeaderCell(
                    text: 'İkil',
                    onTap: () => _toggleGroup(const [
                      'O ikisi (er.)',
                      'O ikisi (kad.)',
                      'Siz ikiniz (er.)',
                      'Siz ikiniz (kad.)',
                      'Biz',
                    ]),
                  ),
                  _HeaderCell(
                    text: 'Tekil',
                    onTap: () => _toggleGroup(const [
                      'O (er.)',
                      'O (kad.)',
                      'Sen (er.)',
                      'Sen (kad.)',
                      'Ben',
                    ]),
                  ),
                  const _HeaderCell(text: 'Şahıs'),
                ],
              ),
              _row(
                '3. Şh. Müzekker\n(Gâib)',
                'Onlar (er.)',
                'O ikisi (er.)',
                'O (er.)',
              ),
              _row(
                '3. Şh. Müennes\n(Gâibe)',
                'Onlar (kad.)',
                'O ikisi (kad.)',
                'O (kad.)',
              ),
              _row(
                '2. Şh. Müzekker\n(Muhatab)',
                'Siz (er.)',
                'Siz ikiniz (er.)',
                'Sen (er.)',
              ),
              _row(
                '2. Şh. Müennes\n(Muhataba)',
                'Siz (kad.)',
                'Siz ikiniz (kad.)',
                'Sen (kad.)',
              ),
              _row('1. Şh. Ortak\n(Mütekellim)', 'Biz', 'Biz', 'Ben'),
            ],
          ),
        ),
      ],
    );
  }

  TableRow _row(String label, String plural, String dual, String singular) {
    final values = [plural, dual, singular];
    return TableRow(
      children: [
        for (final value in values)
          _SelectableCell(
            text: value,
            selected: selected.contains(value),
            onTap: () => onChanged(_toggled(selected, value)),
          ),
        _HeaderCell(text: label, onTap: () => _toggleGroup(values)),
      ],
    );
  }
}

class _NounFilters extends StatelessWidget {
  const _NounFilters({required this.selected, required this.onChanged});

  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionHeader(
          title: 'Dil Bilgisi (İsimler)',
          onSelectAll: () => onChanged({...selected, ...nounPracticeGroups}),
          onClearAll: () =>
              onChanged({...selected}..removeAll(nounPracticeGroups)),
        ),
        _FilterTable(
          child: Table(
            border: const TableBorder(
              verticalInside: BorderSide(color: Color(0xFFD8D1C1)),
            ),
            children: [
              TableRow(
                children: [
                  for (final group in nounPracticeGroups.reversed)
                    _SelectableCell(
                      text: group,
                      selected: selected.contains(group),
                      onTap: () => onChanged(_toggled(selected, group)),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.onSelectAll,
    required this.onClearAll,
  });

  final String title;
  final VoidCallback onSelectAll;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        _TextAction(label: 'Tümünü Seç', onTap: onSelectAll),
        const Text('|', style: TextStyle(color: Colors.grey, fontSize: 12)),
        _TextAction(label: 'Temizle', onTap: onClearAll),
      ],
    );
  }
}

class _TextAction extends StatelessWidget {
  const _TextAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _CategoryOption extends StatelessWidget {
  const _CategoryOption({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final FormCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? scheme.primaryContainer.withValues(alpha: 0.55)
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? scheme.primary : const Color(0xFFD8D1C1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.check_box : Icons.check_box_outline_blank,
              size: 20,
              color: selected ? scheme.primary : scheme.outline,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(category.label, style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTable extends StatelessWidget {
  const _FilterTable({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD8D1C1)),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _SelectableCell extends StatelessWidget {
  const _SelectableCell({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        color: selected
            ? scheme.primaryContainer.withValues(alpha: 0.55)
            : null,
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? scheme.primary : null,
          ),
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.text, this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: onTap == null ? null : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
    return Container(
      color: const Color(0xFFF4F0E6),
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}

Set<T> _toggled<T>(Set<T> values, T value) {
  final next = {...values};
  next.contains(value) ? next.remove(value) : next.add(value);
  return next;
}
