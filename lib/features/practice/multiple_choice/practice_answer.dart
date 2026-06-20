import 'package:flutter/material.dart';

class PracticeAnswerFeedback extends StatelessWidget {
  const PracticeAnswerFeedback({required this.isCorrect, super.key});

  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    final accent = isCorrect
        ? const Color(0xFF2F7D46)
        : const Color(0xFFB43C3C);
    final background = isCorrect
        ? const Color(0xFFE8F5EC)
        : const Color(0xFFFFECEC);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: accent,
            size: 22,
          ),
          const SizedBox(width: 8),
          Text(
            isCorrect ? 'Doğru' : 'Tekrar Bak',
            style: TextStyle(
              color: accent,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
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
    final (borderColor, backgroundColor) = switch ((
      isCorrect,
      isWrong,
      isSelected,
    )) {
      (true, _, _) => (const Color(0xFF2F7D46), const Color(0xFFE8F5EC)),
      (_, true, _) => (const Color(0xFFB43C3C), const Color(0xFFFFECEC)),
      (_, _, true) => (scheme.primary, scheme.primaryContainer),
      _ => (const Color(0xFFE6E1D5), Colors.white),
    };

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
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
            if (isCorrect)
              const Icon(Icons.check_circle, color: Color(0xFF2F7D46))
            else if (isWrong)
              const Icon(Icons.cancel, color: Color(0xFFB43C3C)),
          ],
        ),
      ),
    );
  }
}
