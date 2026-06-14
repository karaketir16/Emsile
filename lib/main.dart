import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const EmsileApp());
}

class EmsileApp extends StatelessWidget {
  const EmsileApp({super.key});

  static final Future<AppData> _appData = EmsileRepository.load();

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1F6F5B),
    );

    return MaterialApp(
      title: 'Emsile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF7F6F0),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.w800),
          titleLarge: TextStyle(fontWeight: FontWeight.w800),
          titleMedium: TextStyle(fontWeight: FontWeight.w700),
          bodyLarge: TextStyle(height: 1.35),
          bodyMedium: TextStyle(height: 1.35),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFFE6E1D5)),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: colorScheme.primaryContainer,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      ),
      home: FutureBuilder<AppData>(
        future: _appData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return LoadErrorScreen(error: snapshot.error.toString());
          }

          if (!snapshot.hasData) {
            return const LoadingScreen();
          }

          return AppShell(data: snapshot.data!);
        },
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({required this.data, super.key});

  final AppData data;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(data: widget.data),
      LessonsScreen(data: widget.data),
      ConjugationScreen(data: widget.data),
      PracticeScreen(data: widget.data),
      const SourceScreen(),
    ];

    return Scaffold(
      body: SafeArea(child: screens[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Ana',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Dersler',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Tablo',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz),
            label: 'Pratik',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'Kaynak',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.data, super.key});

  final AppData data;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Emsile',
      subtitle: 'Sarf tablolarını oku, seç, tekrar et.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FeaturedStudyCard(),
          const SizedBox(height: 16),
          Text('Bugünkü Akış', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          const StudyStep(
            icon: Icons.filter_1,
            title: 'Emsile-i Muhtelife',
            body: 'Temel formları ve anlam karşılıklarını gözden geçir.',
          ),
          const StudyStep(
            icon: Icons.filter_2,
            title: 'Fiil-i Mâzi',
            body: 'Malum ve meçhul çekimleri şahıslara göre incele.',
          ),
          const StudyStep(
            icon: Icons.filter_3,
            title: 'Hızlı Pratik',
            body: 'Arapça formdan Türkçe anlama kısa tekrar yap.',
          ),
          const SizedBox(height: 16),
          Text('Örnek Form', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          ArabicResultCard(form: data.forms.first),
        ],
      ),
    );
  }
}

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
              Text('Örnekler', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              for (final form in relatedForms) ...[
                ArabicResultCard(form: form),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ConjugationScreen extends StatefulWidget {
  const ConjugationScreen({required this.data, super.key});

  final AppData data;

  @override
  State<ConjugationScreen> createState() => _ConjugationScreenState();
}

class _ConjugationScreenState extends State<ConjugationScreen> {
  FormCategory _category = FormCategory.mazi;
  Voice _voice = Voice.malum;
  int _formIndex = 0;

  List<ConjugationForm> get _visibleForms {
    return widget.data.forms
        .where((form) => form.category == _category && form.voice == _voice)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final forms = _visibleForms;
    final activeForm = forms[_formIndex.clamp(0, forms.length - 1)];

    return AppPage(
      title: 'Çekim Tablosu',
      subtitle: 'Nasara örneği üzerinden seç, gör, karşılaştır.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedButton<FormCategory>(
            segments: const [
              ButtonSegment(
                value: FormCategory.mazi,
                icon: Icon(Icons.history),
                label: Text('Mâzi'),
              ),
              ButtonSegment(
                value: FormCategory.muzari,
                icon: Icon(Icons.update),
                label: Text('Muzâri'),
              ),
            ],
            selected: {_category},
            onSelectionChanged: (value) {
              setState(() {
                _category = value.first;
                _formIndex = 0;
              });
            },
          ),
          const SizedBox(height: 12),
          SegmentedButton<Voice>(
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
            selected: {_voice},
            onSelectionChanged: (value) {
              setState(() {
                _voice = value.first;
                _formIndex = 0;
              });
            },
          ),
          const SizedBox(height: 16),
          ArabicResultCard(form: activeForm),
          const SizedBox(height: 16),
          Text('Şahıs Seç', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var index = 0; index < forms.length; index++)
                ChoiceChip(
                  label: Text(forms[index].pronounLabel),
                  selected: index == _formIndex,
                  onSelected: (_) => setState(() => _formIndex = index),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Text('Tüm Formlar', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          for (final form in forms) CompactFormRow(form: form),
        ],
      ),
    );
  }
}

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({required this.data, super.key});

  final AppData data;

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  int _questionIndex = 0;
  String? _selectedAnswer;

  PracticeQuestion get _question =>
      widget.data.practiceQuestions[_questionIndex];

  @override
  Widget build(BuildContext context) {
    final question = _question;
    final isAnswered = _selectedAnswer != null;
    final isCorrect = _selectedAnswer == question.answer;

    return AppPage(
      title: 'Pratik',
      subtitle: 'Formu gör, anlamı hatırla.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_questionIndex + 1}/${widget.data.practiceQuestions.length}',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(question.prompt),
                  const SizedBox(height: 14),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      question.arabic,
                      textAlign: TextAlign.center,
                      style: arabicTextStyle(42),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (final option in question.options) ...[
            AnswerButton(
              text: option,
              isSelected: _selectedAnswer == option,
              isCorrect: isAnswered && option == question.answer,
              isWrong:
                  isAnswered &&
                  _selectedAnswer == option &&
                  option != question.answer,
              onTap: () => setState(() => _selectedAnswer = option),
            ),
            const SizedBox(height: 10),
          ],
          if (isAnswered) ...[
            const SizedBox(height: 10),
            InfoPanel(
              title: isCorrect ? 'Doğru' : 'Tekrar Bak',
              body: isCorrect
                  ? question.explanation
                  : 'Doğru cevap: ${question.answer}. ${question.explanation}',
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                setState(() {
                  _questionIndex =
                      (_questionIndex + 1) %
                      widget.data.practiceQuestions.length;
                  _selectedAnswer = null;
                });
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Sonraki Soru'),
            ),
          ],
        ],
      ),
    );
  }
}

class SourceScreen extends StatelessWidget {
  const SourceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPage(
      title: 'Kaynak',
      subtitle: 'İçerik kaynağı ve yerel PDF bilgisi.',
      child: Column(
        children: [
          InfoPanel(
            title: 'Kaynak',
            body:
                'Zafer ESEN tarafından hazırlanan Emsile Ders Notu temel alınmıştır. Güncelleme tarihi: 01.01.2025.',
          ),
          SizedBox(height: 12),
          InfoPanel(
            title: 'Yerel PDF',
            body: 'docs/Emsile_Ders_Notu_Zafer_ESEN_01.01.2025.pdf',
          ),
          SizedBox(height: 12),
          InfoPanel(
            title: 'Kullanım Notu',
            body:
                'Uygulamada kaynak gösterimi korunmalı; içerik genişletilirken PDF verileri elle kontrol edilmelidir.',
          ),
        ],
      ),
    );
  }
}

class AppPage extends StatelessWidget {
  const AppPage({
    required this.title,
    required this.subtitle,
    required this.child,
    this.leading,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverToBoxAdapter(child: child),
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturedStudyCard extends StatelessWidget {
  const FeaturedStudyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kaldığın Yer',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: scheme.onPrimary.withValues(alpha: 0.82),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fiil-i Mâzi Bina-i Malum',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: scheme.onPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Bugün hedef: 14 şahıs çekimini tanımak ve 5 kart çözmek.',
            softWrap: true,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: scheme.onPrimary),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.35,
            color: const Color(0xFFE2B84B),
            backgroundColor: scheme.onPrimary.withValues(alpha: 0.24),
            borderRadius: BorderRadius.circular(99),
          ),
        ],
      ),
    );
  }
}

class StudyStep extends StatelessWidget {
  const StudyStep({
    required this.icon,
    required this.title,
    required this.body,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(body),
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

class ArabicResultCard extends StatelessWidget {
  const ArabicResultCard({required this.form, super.key});

  final ConjugationForm form;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${form.category.label} · ${form.voice.label} · ${form.pronounLabel}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 10),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                form.arabic,
                textAlign: TextAlign.center,
                style: arabicTextStyle(44),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              form.meaning,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              form.rule,
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}

class CompactFormRow extends StatelessWidget {
  const CompactFormRow({required this.form, super.key});

  final ConjugationForm form;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                form.pronounLabel,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  form.arabic,
                  textAlign: TextAlign.right,
                  style: arabicTextStyle(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
    super.key,
  });

  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Color borderColor;
    final Color backgroundColor;

    if (isCorrect) {
      borderColor = const Color(0xFF2F7D46);
      backgroundColor = const Color(0xFFE8F5EC);
    } else if (isWrong) {
      borderColor = const Color(0xFFB43C3C);
      backgroundColor = const Color(0xFFFFECEC);
    } else if (isSelected) {
      borderColor = scheme.primary;
      backgroundColor = scheme.primaryContainer;
    } else {
      borderColor = const Color(0xFFE6E1D5);
      backgroundColor = Colors.white;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class InfoPanel extends StatelessWidget {
  const InfoPanel({required this.title, required this.body, super.key});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(body),
          ],
        ),
      ),
    );
  }
}

TextStyle arabicTextStyle(double size) {
  return TextStyle(
    fontSize: size,
    height: 1.55,
    fontWeight: FontWeight.w800,
    fontFamily: 'Times New Roman',
  );
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class LoadErrorScreen extends StatelessWidget {
  const LoadErrorScreen({required this.error, super.key});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Veri yüklenemedi: $error'),
        ),
      ),
    );
  }
}

class EmsileRepository {
  const EmsileRepository._();

  static Future<AppData> load() async {
    final rawJson = await rootBundle.loadString('assets/data/emsile_seed.json');
    final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
    return AppData.fromJson(decoded);
  }
}

class AppData {
  const AppData({
    required this.lessons,
    required this.forms,
    required this.practiceQuestions,
  });

  final List<Lesson> lessons;
  final List<ConjugationForm> forms;
  final List<PracticeQuestion> practiceQuestions;

  factory AppData.fromJson(Map<String, dynamic> json) {
    return AppData(
      lessons: (json['lessons'] as List<dynamic>)
          .map((item) => Lesson.fromJson(item as Map<String, dynamic>))
          .toList(),
      forms: (json['forms'] as List<dynamic>)
          .map((item) => ConjugationForm.fromJson(item as Map<String, dynamic>))
          .toList(),
      practiceQuestions: (json['practiceQuestions'] as List<dynamic>)
          .map(
            (item) => PracticeQuestion.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

enum FormCategory {
  mazi('Mâzi'),
  muzari('Muzâri');

  const FormCategory(this.label);
  final String label;

  static FormCategory fromJson(String value) {
    return FormCategory.values.firstWhere((category) => category.name == value);
  }
}

enum Voice {
  malum('Malum'),
  mechul('Meçhul');

  const Voice(this.label);
  final String label;

  static Voice fromJson(String value) {
    return Voice.values.firstWhere((voice) => voice.name == value);
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

class ConjugationForm {
  const ConjugationForm({
    required this.category,
    required this.voice,
    required this.pronounLabel,
    required this.arabic,
    required this.meaning,
    required this.rule,
  });

  final FormCategory category;
  final Voice voice;
  final String pronounLabel;
  final String arabic;
  final String meaning;
  final String rule;

  factory ConjugationForm.fromJson(Map<String, dynamic> json) {
    return ConjugationForm(
      category: FormCategory.fromJson(json['category'] as String),
      voice: Voice.fromJson(json['voice'] as String),
      pronounLabel: json['pronounLabel'] as String,
      arabic: json['arabic'] as String,
      meaning: json['meaning'] as String,
      rule: json['rule'] as String,
    );
  }
}

class PracticeQuestion {
  const PracticeQuestion({
    required this.prompt,
    required this.arabic,
    required this.options,
    required this.answer,
    required this.explanation,
  });

  final String prompt;
  final String arabic;
  final List<String> options;
  final String answer;
  final String explanation;

  factory PracticeQuestion.fromJson(Map<String, dynamic> json) {
    return PracticeQuestion(
      prompt: json['prompt'] as String,
      arabic: json['arabic'] as String,
      options: (json['options'] as List<dynamic>).cast<String>(),
      answer: json['answer'] as String,
      explanation: json['explanation'] as String,
    );
  }
}
