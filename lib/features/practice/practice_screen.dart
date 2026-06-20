import 'dart:math';

import 'package:emsile_flutter/data/models.dart';
import 'package:emsile_flutter/features/practice/matching_practice_screen.dart';
import 'package:emsile_flutter/features/practice/multiple_choice/multiple_choice_practice_screen.dart';
import 'package:emsile_flutter/features/practice/table_fill_practice_screen.dart';
import 'package:emsile_flutter/shared/widgets/app_page.dart';
import 'package:emsile_flutter/shared/widgets/navigation_card.dart';
import 'package:flutter/material.dart';

export 'package:emsile_flutter/features/practice/multiple_choice/multiple_choice_practice_screen.dart'
    show MultipleChoicePracticeScreen;
export 'package:emsile_flutter/features/practice/multiple_choice/practice_answer.dart'
    show AnswerButton;

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({required this.data, this.random, super.key});

  final AppData data;
  final Random? random;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Pratik',
      subtitle: 'Çalışma biçimini seç.',
      child: Column(
        children: [
          NavigationCard(
            icon: Icons.compare_arrows_outlined,
            title: 'Emsile-i Muhtelife Alıştırması',
            subtitle:
                'Arapça sîgaları doğru dilbilgisi adları veya anlamlarıyla eşleştir.',
            onTap: () => _open(
              context,
              MatchingPracticeScreen(data: data, random: random),
            ),
          ),
          const SizedBox(height: 12),
          NavigationCard(
            icon: Icons.quiz_outlined,
            title: 'Çoktan Seçmeli',
            subtitle:
                'Arapça ve Türkçe anlamlar arasında doğru cevabı seçeneklerden bul.',
            onTap: () => _open(
              context,
              MultipleChoicePracticeScreen(data: data, random: random),
            ),
          ),
          const SizedBox(height: 12),
          NavigationCard(
            icon: Icons.view_module_outlined,
            title: 'Tabloyu Doldur',
            subtitle:
                'Karışık verilen çekimleri sürükleyerek doğru tablo hücrelerine yerleştir.',
            onTap: () => _open(
              context,
              TableFillPracticeScreen(data: data, random: random),
            ),
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, Widget child) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(body: SafeArea(child: child)),
      ),
    );
  }
}
