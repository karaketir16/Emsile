import 'package:emsile_flutter/data/models.dart';
import 'package:emsile_flutter/domain/conjugation/form_selection.dart';
import 'package:emsile_flutter/features/conjugation/widgets/conjugation_grid.dart';
import 'package:emsile_flutter/shared/widgets/arabic_text.dart';
import 'package:flutter/material.dart';

class SelectionTable extends StatelessWidget {
  const SelectionTable({
    required this.forms,
    required this.selectedForm,
    required this.onSelect,
    super.key,
  });

  final List<ConjugationForm> forms;
  final FormSelection selectedForm;
  final ValueChanged<FormSelection> onSelect;

  @override
  Widget build(BuildContext context) {
    final rows = [
      for (final row in conjugationRows)
        ConjugationTableRow(
          label: row.label,
          cells: [
            for (final column in conjugationColumns)
              (
                form: findConjugationForm(
                  forms,
                  row.selectionFor(column.number),
                ),
                selection: row.selectionFor(column.number),
              ),
          ],
        ),
    ];

    return ConjugationGrid(
      rows: rows,
      dataColumnWidths: measureConjugationColumns(
        rows,
        textForCell: (data) =>
            (data as ({ConjugationForm? form, FormSelection selection}))
                .form
                ?.pronounLabel,
        textStyle: Theme.of(context).textTheme.labelMedium,
      ),
      cellBuilder: (context, data) {
        final cell = data as ({ConjugationForm? form, FormSelection selection});
        final form = cell.form;
        if (form == null) return const SizedBox.shrink();
        final selected =
            selectedForm.person == cell.selection.person &&
            selectedForm.number == cell.selection.number &&
            selectedForm.gender == cell.selection.gender;
        return _SelectableCell(
          selected: selected,
          fillUnselected: true,
          onTap: () => onSelect(cell.selection),
          child: Text(
            form.pronounLabel,
            textAlign: TextAlign.center,
            maxLines: 1,
            softWrap: false,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}

class FormsTable extends StatelessWidget {
  const FormsTable({
    required this.forms,
    required this.selectedForm,
    required this.activeCategory,
    required this.activeVoice,
    required this.onSelect,
    this.highlightSelection = true,
    super.key,
  });

  final List<ConjugationForm> forms;
  final FormSelection selectedForm;
  final FormCategory activeCategory;
  final Voice activeVoice;
  final ValueChanged<FormSelection> onSelect;
  final bool highlightSelection;

  @override
  Widget build(BuildContext context) {
    final rows = [
      for (final row in conjugationRows)
        ConjugationTableRow(
          label: row.label,
          cells: [
            for (final column in conjugationColumns)
              findConjugationForm(forms, row.selectionFor(column.number)),
          ],
        ),
    ];

    return ConjugationGrid(
      rows: rows,
      dataColumnWidths: measureConjugationColumns(
        rows,
        textForCell: (data) => (data as ConjugationForm?)?.arabic,
        textStyle: arabicTextStyle(20),
        textDirection: TextDirection.rtl,
      ),
      cellBuilder: (context, data) {
        final form = data as ConjugationForm?;
        if (form == null) return const SizedBox.shrink();
        final selected =
            highlightSelection &&
            activeCategory == form.category &&
            activeVoice == form.voice &&
            selectedForm.matches(form);
        return _SelectableCell(
          selected: selected,
          subtleSelection: true,
          onTap: () => onSelect(FormSelection.fromForm(form)),
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
        );
      },
    );
  }
}

class _SelectableCell extends StatelessWidget {
  const _SelectableCell({
    required this.selected,
    required this.onTap,
    required this.child,
    this.subtleSelection = false,
    this.fillUnselected = false,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;
  final bool subtleSelection;
  final bool fillUnselected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: selected
              ? subtleSelection
                    ? scheme.primaryContainer.withValues(alpha: 0.55)
                    : scheme.primaryContainer
              : fillUnselected
              ? Colors.white
              : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: selected ? scheme.onPrimaryContainer : null),
          child: child,
        ),
      ),
    );
  }
}
