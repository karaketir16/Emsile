import 'package:emsile_flutter/data/models.dart';
import 'package:emsile_flutter/domain/conjugation/form_selection.dart';
import 'package:emsile_flutter/features/conjugation/widgets/conjugation_grid.dart';
import 'package:emsile_flutter/shared/widgets/arabic_text.dart';
import 'package:emsile_flutter/shared/widgets/info_panel.dart';
import 'package:flutter/material.dart';

class PronounsPanel extends StatelessWidget {
  const PronounsPanel({
    required this.pronouns,
    required this.selectedKind,
    required this.onKindChanged,
    super.key,
  });

  final List<PronounEntry> pronouns;
  final PronounKind selectedKind;
  final ValueChanged<PronounKind> onKindChanged;

  @override
  Widget build(BuildContext context) {
    final visible = pronouns
        .where((pronoun) => pronoun.kind == selectedKind)
        .toList();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedButton<PronounKind>(
            expandedInsets: EdgeInsets.zero,
            segments: const [
              ButtonSegment(
                value: PronounKind.independent,
                icon: Icon(Icons.person_outline),
                label: Text('Ayrı'),
              ),
              ButtonSegment(
                value: PronounKind.attached,
                icon: Icon(Icons.link),
                label: Text('Bitişik'),
              ),
            ],
            selected: {selectedKind},
            onSelectionChanged: (value) => onKindChanged(value.first),
          ),
          const SizedBox(height: 14),
          InfoPanel(
            title: selectedKind.label,
            body: selectedKind == PronounKind.independent
                ? 'Şahıs zamirleri, fiil çekimindeki şahıs düzenini okumak için temel tablodur.'
                : 'Bitişik zamirler isim, harf ve fiile eklenir; fiile geldiğinde çoğunlukla mef’ul anlamı verir.',
          ),
          const SizedBox(height: 14),
          if (visible.isEmpty)
            const Center(child: Text('Gösterilecek zamir verisi yok.'))
          else
            PronounTable(pronouns: visible),
          if (selectedKind == PronounKind.attached) ...[
            const SizedBox(height: 14),
            const InfoPanel(
              title: 'Fiile gelince',
              body:
                  'Örnek: ضَرَبْتُهُ kelimesinde تُ faili, هُ ise fiile bitişen mef’ul zamiridir.',
            ),
          ],
        ],
      ),
    );
  }
}

class PronounTable extends StatelessWidget {
  const PronounTable({required this.pronouns, super.key});

  final List<PronounEntry> pronouns;

  @override
  Widget build(BuildContext context) {
    final rows = [
      for (final row in conjugationRows)
        ConjugationTableRow(
          label: row.label,
          cells: [
            for (final column in conjugationColumns)
              findPronoun(pronouns, row.selectionFor(column.number)),
          ],
        ),
    ];
    return ConjugationGrid(
      rows: rows,
      dataColumnWidths: measureConjugationColumns(
        rows,
        textForCell: (data) => (data as PronounEntry?)?.arabic,
        textStyle: arabicTextStyle(21),
        textDirection: TextDirection.rtl,
      ),
      cellBuilder: (context, data) {
        final pronoun = data as PronounEntry?;
        if (pronoun == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  pronoun.arabic,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  softWrap: false,
                  style: arabicTextStyle(21),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                pronoun.labelTr,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        );
      },
    );
  }
}
