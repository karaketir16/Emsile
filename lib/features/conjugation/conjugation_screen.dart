import 'package:emsile_flutter/data/models.dart';
import 'package:emsile_flutter/domain/conjugation/form_selection.dart';
import 'package:emsile_flutter/features/conjugation/widgets/forms_tables.dart';
import 'package:emsile_flutter/features/conjugation/widgets/noun_forms_table.dart';
import 'package:emsile_flutter/features/conjugation/widgets/pronouns_panel.dart';
import 'package:emsile_flutter/shared/widgets/app_page.dart';
import 'package:emsile_flutter/shared/widgets/arabic_result_card.dart';
import 'package:emsile_flutter/shared/widgets/navigation_card.dart';
import 'package:flutter/material.dart';

export 'package:emsile_flutter/domain/conjugation/form_selection.dart'
    show FormSelection;
export 'package:emsile_flutter/features/conjugation/widgets/forms_tables.dart'
    show FormsTable, SelectionTable;
export 'package:emsile_flutter/features/conjugation/widgets/noun_forms_table.dart'
    show NounFormsTable;
export 'package:emsile_flutter/features/conjugation/widgets/pronouns_panel.dart'
    show PronounTable, PronounsPanel;

class ConjugationScreen extends StatelessWidget {
  const ConjugationScreen({required this.data, super.key});

  final AppData data;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppPage(
      title: 'Çekim Tablosu',
      scrollable: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            NavigationCard(
              icon: Icons.grid_view_outlined,
              title: 'Çekimler',
              subtitle: 'Fiil ve isim çekim tablolarını incele',
              iconBackground: scheme.primaryContainer,
              iconColor: scheme.primary,
              onTap: () => _open(context, _ConjugationsPage(data: data)),
            ),
            const SizedBox(height: 16),
            NavigationCard(
              icon: Icons.badge_outlined,
              title: 'Zamirler',
              subtitle: 'Ayrı ve bitişik şahıs zamirlerini gör',
              iconBackground: scheme.secondaryContainer,
              iconColor: scheme.secondary,
              onTap: () =>
                  _open(context, _PronounsPage(pronouns: data.pronouns)),
            ),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }
}

class _PronounsPage extends StatefulWidget {
  const _PronounsPage({required this.pronouns});

  final List<PronounEntry> pronouns;

  @override
  State<_PronounsPage> createState() => _PronounsPageState();
}

class _PronounsPageState extends State<_PronounsPage> {
  PronounKind _kind = PronounKind.independent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zamirler'), centerTitle: false),
      body: SafeArea(
        child: AppPage(
          title: 'Zamirler',
          scrollable: false,
          child: PronounsPanel(
            pronouns: widget.pronouns,
            selectedKind: _kind,
            onKindChanged: (kind) => setState(() => _kind = kind),
          ),
        ),
      ),
    );
  }
}

class _ConjugationsPage extends StatefulWidget {
  const _ConjugationsPage({required this.data});

  final AppData data;

  @override
  State<_ConjugationsPage> createState() => _ConjugationsPageState();
}

class _ConjugationsPageState extends State<_ConjugationsPage> {
  FormCategory _category = FormCategory.mazi;
  Voice _voice = Voice.malum;
  FormSelection _selection = const FormSelection(
    person: FormPerson.third,
    number: FormNumber.singular,
    gender: FormGender.masculine,
  );

  @override
  void initState() {
    super.initState();
    if (widget.data.forms.isNotEmpty &&
        !widget.data.forms.any((form) => form.category == _category)) {
      _category = widget.data.forms.first.category;
    }
  }

  List<ConjugationForm> get _forms => widget.data.forms.where((form) {
    return form.category == _category &&
        (_category.isNoun || form.voice == _voice);
  }).toList();

  bool _hasMechul(FormCategory category) => widget.data.forms.any(
    (form) => form.category == category && form.voice == Voice.mechul,
  );

  void _update({
    FormCategory? category,
    Voice? voice,
    FormSelection? selectedForm,
  }) {
    setState(() {
      _category = category ?? _category;
      _voice = voice ?? _voice;
      if (!_hasMechul(_category)) _voice = Voice.malum;

      var candidate = selectedForm ?? _selection;
      if (category != null || voice != null) {
        candidate = FormSelection(
          person: candidate.person,
          number: candidate.number,
          gender: candidate.gender,
        );
      }
      final forms = _forms;
      final match = findConjugationForm(forms, candidate);
      _selection = match != null
          ? FormSelection.fromForm(match)
          : forms.isNotEmpty
          ? FormSelection.fromForm(forms.first)
          : candidate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final forms = _forms;
    final active = forms.isEmpty
        ? null
        : findConjugationForm(forms, _selection) ?? forms.first;
    return Scaffold(
      appBar: AppBar(title: const Text('Çekimler'), centerTitle: false),
      body: SafeArea(
        child: AppPage(
          title: 'Çekimler',
          scrollable: false,
          child: active == null
              ? const Center(child: Text('Gösterilecek çekim formu yok.'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ArabicResultCard(form: active),
                    const SizedBox(height: 10),
                    if (_category.isVerb) ...[
                      if (_hasMechul(_category))
                        _VoiceSelector(value: _voice, onChanged: _update)
                      else
                        const Text('Malûmdan olup meçhulleri gelmez.'),
                      const SizedBox(height: 16),
                    ],
                    Expanded(
                      child: SingleChildScrollView(
                        child: _ConjugationContent(
                          data: widget.data,
                          category: _category,
                          voice: _voice,
                          forms: forms,
                          selection: _selection,
                          onChanged: _update,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _VoiceSelector extends StatelessWidget {
  const _VoiceSelector({required this.value, required this.onChanged});

  final Voice value;
  final void Function({Voice? voice}) onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Voice>(
      expandedInsets: EdgeInsets.zero,
      segments: const [
        ButtonSegment(
          value: Voice.malum,
          icon: Icon(Icons.record_voice_over),
          label: Text('Malum'),
        ),
        ButtonSegment(
          value: Voice.mechul,
          icon: Icon(Icons.visibility_off_outlined),
          label: Text('Meçhul'),
        ),
      ],
      selected: {value},
      onSelectionChanged: (selection) => onChanged(voice: selection.first),
    );
  }
}

class _ConjugationContent extends StatelessWidget {
  const _ConjugationContent({
    required this.data,
    required this.category,
    required this.voice,
    required this.forms,
    required this.selection,
    required this.onChanged,
  });

  final AppData data;
  final FormCategory category;
  final Voice voice;
  final List<ConjugationForm> forms;
  final FormSelection selection;
  final void Function({
    FormCategory? category,
    Voice? voice,
    FormSelection? selectedForm,
  })
  onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        DropdownButtonFormField<FormCategory>(
          value: category,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Çekim Grubu',
            prefixIcon: Icon(Icons.view_list_outlined),
            border: OutlineInputBorder(),
          ),
          items: [
            for (final item in FormCategory.values)
              DropdownMenuItem(value: item, child: Text(item.label)),
          ],
          onChanged: (value) {
            if (value != null) onChanged(category: value);
          },
        ),
        const SizedBox(height: 16),
        Text(
          category.isVerb ? 'Şahıs Tablosu' : 'Çekim Tablosu',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        if (category.isVerb) ...[
          SelectionTable(
            forms: forms,
            selectedForm: selection,
            onSelect: (value) => onChanged(selectedForm: value),
          ),
          const SizedBox(height: 18),
          Text(
            'Seçili Tablo (${category.label} - ${voice.label})',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          FormsTable(
            forms: forms,
            selectedForm: selection,
            activeCategory: category,
            activeVoice: voice,
            onSelect: (value) => onChanged(selectedForm: value),
          ),
        ] else
          NounFormsTable(
            forms: forms,
            selectedForm: selection,
            onSelect: (value) => onChanged(selectedForm: value),
          ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => _AllTablesPage(
                data: data,
                selectedForm: selection,
                activeCategory: category,
                activeVoice: voice,
                onSelect: onChanged,
              ),
            ),
          ),
          icon: const Icon(Icons.table_rows_outlined),
          label: const Text('Tüm Muttaride Tablolarını Gör'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
        ),
      ],
    );
  }
}

class _AllTablesPage extends StatelessWidget {
  const _AllTablesPage({
    required this.data,
    required this.selectedForm,
    required this.activeCategory,
    required this.activeVoice,
    required this.onSelect,
  });

  final AppData data;
  final FormSelection selectedForm;
  final FormCategory activeCategory;
  final Voice activeVoice;
  final void Function({
    FormCategory? category,
    Voice? voice,
    FormSelection? selectedForm,
  })
  onSelect;

  Iterable<(FormCategory, Voice, List<ConjugationForm>)> get _groups sync* {
    for (final category in FormCategory.values) {
      for (final voice in Voice.values) {
        final forms = data.forms.where((form) {
          return form.category == category && form.voice == voice;
        }).toList();
        if (forms.isNotEmpty) yield (category, voice, forms);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tüm Muttaride Tabloları'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: AppPage(
          title: 'Tüm Tablolar',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (category, voice, forms) in _groups) ...[
                Text(
                  category.isVerb
                      ? '${category.label} (${voice.label})'
                      : category.label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                if (category.isVerb)
                  FormsTable(
                    forms: forms,
                    selectedForm: selectedForm,
                    activeCategory: category,
                    activeVoice: voice,
                    highlightSelection:
                        category == activeCategory && voice == activeVoice,
                    onSelect: (selection) {
                      onSelect(
                        category: category,
                        voice: voice,
                        selectedForm: selection,
                      );
                      Navigator.of(context).pop();
                    },
                  )
                else
                  NounFormsTable(
                    forms: forms,
                    selectedForm: selectedForm,
                    highlightSelection: category == activeCategory,
                    onSelect: (selection) {
                      onSelect(category: category, selectedForm: selection);
                      Navigator.of(context).pop();
                    },
                  ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
