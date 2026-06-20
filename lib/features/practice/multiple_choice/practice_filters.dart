import 'package:emsile_flutter/data/models.dart';
import 'package:flutter/material.dart';

class PracticeFilters extends StatelessWidget {
  const PracticeFilters({
    required this.availableForms,
    required this.categories,
    required this.voices,
    required this.includeBrokenPlurals,
    required this.onCategoriesChanged,
    required this.onVoicesChanged,
    required this.onIncludeBrokenPluralsChanged,
    super.key,
  });

  final List<ConjugationForm> availableForms;
  final Set<FormCategory> categories;
  final Set<Voice> voices;
  final bool includeBrokenPlurals;
  final ValueChanged<Set<FormCategory>> onCategoriesChanged;
  final ValueChanged<Set<Voice>> onVoicesChanged;
  final ValueChanged<bool> onIncludeBrokenPluralsChanged;

  bool get _showVerbs => categories.isEmpty
      ? availableForms.any((form) => form.category.isVerb)
      : categories.any((category) => category.isVerb);

  bool get _showBrokenPluralOption {
    return availableForms.any(
      (form) =>
          categories.contains(form.category) &&
          form.category.isNoun &&
          form.isBrokenPlural,
    );
  }

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
        ],
        if (_showBrokenPluralOption) ...[
          const SizedBox(height: 20),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Kırık Çoğullar'),
            subtitle: const Text(
              'Kırık çoğulları soru ve seçeneklere dahil et.',
            ),
            value: includeBrokenPlurals,
            onChanged: onIncludeBrokenPluralsChanged,
          ),
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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFD8D1C1)),
          ),
          clipBehavior: Clip.antiAlias,
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

Set<T> _toggled<T>(Set<T> values, T value) {
  final next = {...values};
  next.contains(value) ? next.remove(value) : next.add(value);
  return next;
}
