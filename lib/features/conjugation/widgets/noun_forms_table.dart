import 'package:emsile_flutter/data/models.dart';
import 'package:emsile_flutter/domain/conjugation/form_selection.dart';
import 'package:emsile_flutter/features/conjugation/widgets/conjugation_grid.dart';
import 'package:emsile_flutter/shared/widgets/arabic_text.dart';
import 'package:flutter/material.dart';

class NounFormsTable extends StatelessWidget {
  const NounFormsTable({
    required this.forms,
    required this.selectedForm,
    required this.onSelect,
    this.highlightSelection = true,
    super.key,
  });

  final List<ConjugationForm> forms;
  final FormSelection selectedForm;
  final ValueChanged<FormSelection> onSelect;
  final bool highlightSelection;

  @override
  Widget build(BuildContext context) {
    final rows = _buildRows();
    final mainForms = rows
        .expand((row) => row.cells)
        .whereType<ConjugationForm>()
        .toSet();
    final brokenPlurals = forms
        .where((form) => !mainForms.contains(form))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConjugationGrid(
          rows: rows,
          dataColumnWidths: measureConjugationColumns(
            rows,
            textForCell: (data) => (data as ConjugationForm?)?.arabic,
            textStyle: arabicTextStyle(20),
            textDirection: TextDirection.rtl,
          ),
          cellBuilder: (context, data) {
            final form = data as ConjugationForm?;
            return form == null
                ? const SizedBox.shrink()
                : _NounFormCell(
                    form: form,
                    selected: highlightSelection && selectedForm.matches(form),
                    onTap: () => onSelect(FormSelection.fromForm(form)),
                  );
          },
        ),
        if (brokenPlurals.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'Kırık Çoğullar (Cemi Mükesser)',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final form in brokenPlurals)
                _BrokenPluralChip(
                  form: form,
                  selected: highlightSelection && selectedForm.matches(form),
                  onTap: () => onSelect(FormSelection.fromForm(form)),
                ),
            ],
          ),
        ],
      ],
    );
  }

  List<ConjugationTableRow> _buildRows() {
    final hasGender = forms.any((form) => form.gender != FormGender.common);
    final genders = hasGender
        ? const [FormGender.masculine, FormGender.feminine]
        : const [FormGender.common];
    return [
      for (final gender in genders)
        ConjugationTableRow(
          label: switch (gender) {
            FormGender.masculine => 'Müzekker',
            FormGender.feminine => 'Müennes',
            FormGender.common => 'Ortak',
          },
          cells: [
            _findMainForm(gender, FormNumber.plural),
            _findMainForm(gender, FormNumber.dual),
            _findMainForm(gender, FormNumber.singular),
          ],
        ),
    ];
  }

  ConjugationForm? _findMainForm(FormGender gender, FormNumber number) {
    for (final form in forms) {
      final genderMatches =
          form.gender == gender ||
          (gender == FormGender.common &&
              !forms.any((item) => item.gender == FormGender.common));
      if (genderMatches && form.number == number && !form.isBrokenPlural) {
        return form;
      }
    }
    return null;
  }
}

class _NounFormCell extends StatelessWidget {
  const _NounFormCell({
    required this.form,
    required this.selected,
    required this.onTap,
  });

  final ConjugationForm form;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        decoration: BoxDecoration(
          color: selected
              ? scheme.primaryContainer.withValues(alpha: 0.55)
              : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            form.arabic,
            textAlign: TextAlign.center,
            maxLines: 1,
            softWrap: false,
            style: arabicTextStyle(20),
          ),
        ),
      ),
    );
  }
}

class _BrokenPluralChip extends StatelessWidget {
  const _BrokenPluralChip({
    required this.form,
    required this.selected,
    required this.onTap,
  });

  final ConjugationForm form;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? scheme.primaryContainer : Colors.white,
          border: Border.all(
            color: selected ? scheme.primary : const Color(0xFFD8D1C1),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(form.arabic, style: arabicTextStyle(20)),
            ),
            const SizedBox(height: 4),
            Text(
              form.pronounLabel,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
