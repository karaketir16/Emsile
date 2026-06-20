import 'catalog_models.dart';
import 'generators/nasara_muttaride_generator.dart';
import 'models.dart';

class MuttarideGenerator {
  const MuttarideGenerator._();

  static List<ConjugationForm> fromVerbEntry(VerbEntry entry) {
    if (entry.muttarideForms.isNotEmpty) {
      return entry.muttarideForms;
    }

    final source = entry.conjugationSource;
    if (source == null) {
      throw StateError(
        'Verb entry must define muttarideForms or conjugationSource.',
      );
    }
    if (source.strategy != 'generated') {
      throw UnsupportedError(
        'Unsupported conjugation strategy: ${source.strategy}',
      );
    }

    final config = source.generated;
    if (config == null) {
      throw StateError('Generated conjugation source is missing its config.');
    }

    return switch ((config.family, config.verbClass, config.bab)) {
      ('sulasi_mujarrad', 'sahih_salim', 'nasara_yansuru') =>
        NasaraMuttarideGenerator.generate(entry.meta, config),
      _ => throw UnsupportedError(
        'Unsupported generated profile: '
        '${config.family}/${config.verbClass}/${config.bab}',
      ),
    };
  }
}
