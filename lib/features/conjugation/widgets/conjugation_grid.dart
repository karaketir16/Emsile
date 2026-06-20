import 'package:emsile_flutter/domain/conjugation/form_selection.dart';
import 'package:flutter/material.dart';

class ConjugationTableRow {
  const ConjugationTableRow({required this.label, required this.cells});

  final String label;
  final List<Object?> cells;
}

class ConjugationGrid extends StatelessWidget {
  const ConjugationGrid({
    required this.rows,
    required this.cellBuilder,
    this.dataColumnWidths,
    super.key,
  });

  final List<ConjugationTableRow> rows;
  final Widget Function(BuildContext context, Object? data) cellBuilder;
  final List<double>? dataColumnWidths;

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFFD8D1C1);
    final baseDataWidths = dataColumnWidths ?? const [56, 56, 56];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final widths = _expandedWidths(constraints.maxWidth, baseDataWidths);
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                _buildHeader(widths, borderColor),
                for (final row in rows)
                  row.label.startsWith('1. Şahıs')
                      ? _buildFirstPersonRow(context, row, widths, borderColor)
                      : _buildStandardRow(context, row, widths, borderColor),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(List<double> widths, Color borderColor) {
    return Table(
      border: TableBorder.all(color: borderColor),
      columnWidths: _columnWidths(widths),
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFF4F0E6)),
          children: [
            for (final column in conjugationColumns)
              _GridLabel(text: column.label),
            const _GridLabel(text: ''),
          ],
        ),
      ],
    );
  }

  Widget _buildFirstPersonRow(
    BuildContext context,
    ConjugationTableRow row,
    List<double> widths,
    Color borderColor,
  ) {
    return Table(
      border: TableBorder.all(color: borderColor),
      columnWidths: {
        0: FixedColumnWidth(widths[0] + widths[1]),
        1: FixedColumnWidth(widths[2]),
        2: FixedColumnWidth(widths[3]),
      },
      children: [
        TableRow(
          children: [
            _GridDataCell(child: cellBuilder(context, row.cells[0])),
            _GridDataCell(child: cellBuilder(context, row.cells[2])),
            _GridLabel(text: row.label),
          ],
        ),
      ],
    );
  }

  Widget _buildStandardRow(
    BuildContext context,
    ConjugationTableRow row,
    List<double> widths,
    Color borderColor,
  ) {
    return Table(
      border: TableBorder.all(color: borderColor),
      columnWidths: _columnWidths(widths),
      children: [
        TableRow(
          children: [
            for (final cell in row.cells)
              _GridDataCell(child: cellBuilder(context, cell)),
            _GridLabel(text: row.label),
          ],
        ),
      ],
    );
  }

  Map<int, TableColumnWidth> _columnWidths(List<double> widths) {
    return {
      for (var index = 0; index < widths.length; index++)
        index: FixedColumnWidth(widths[index]),
    };
  }
}

List<double> measureConjugationColumns(
  List<ConjugationTableRow> rows, {
  required String? Function(Object? data) textForCell,
  required TextStyle? textStyle,
  TextDirection textDirection = TextDirection.ltr,
}) {
  final widths = [0.0, 0.0, 0.0];
  for (final row in rows) {
    for (var index = 0; index < row.cells.length && index < 3; index++) {
      final text = textForCell(row.cells[index]);
      if (text == null || text.isEmpty) continue;
      final painter = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        textDirection: textDirection,
        maxLines: 1,
      )..layout();
      widths[index] = painter.width + 12 > widths[index]
          ? painter.width + 12
          : widths[index];
    }
  }
  return [for (final width in widths) width < 54 ? 54 : width];
}

List<double> _expandedWidths(double available, List<double> dataWidths) {
  final widths = [...dataWidths.take(3), 80.0];
  final intrinsic = widths.reduce((sum, width) => sum + width);
  if (!available.isFinite || available <= intrinsic) return widths;
  final extra = (available - intrinsic) / widths.length;
  return [for (final width in widths) width + extra];
}

class _GridDataCell extends StatelessWidget {
  const _GridDataCell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: SizedBox(height: 66, child: Center(child: child)),
    );
  }
}

class _GridLabel extends StatelessWidget {
  const _GridLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      color: const Color(0xFFF4F0E6),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
