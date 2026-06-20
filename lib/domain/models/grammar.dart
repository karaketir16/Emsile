enum FormCategory {
  mazi('Fiil-i Mâzi', FormCategoryType.verb),
  muzari('Fiil-i Muzâri', FormCategoryType.verb),
  masdar('Masdar-ı Gayr-ı Mîmî', FormCategoryType.noun),
  ismFail('İsm-i Fâil', FormCategoryType.noun),
  ismMeful('İsm-i Mef’ul', FormCategoryType.noun),
  cahdMutlak('Cahd-ı Mutlak', FormCategoryType.verb),
  cahdMustagrak('Cahd-ı Mustağrak', FormCategoryType.verb),
  nefyHal('Nefy-i Hâl', FormCategoryType.verb),
  nefyIstikbal('Nefy-i İstikbâl', FormCategoryType.verb),
  tekidNefyIstikbal("Te'kid-i Nefy-i İstikbâl", FormCategoryType.verb),
  emrGaib('Emr-i Gâib', FormCategoryType.verb),
  nehyGaib('Nehy-i Gâib', FormCategoryType.verb),
  emrHazir('Emr-i Hâzır', FormCategoryType.verb),
  nehyHazir('Nehy-i Hâzır', FormCategoryType.verb),
  ismZamanMekan('İsm-i Zaman / Mekân', FormCategoryType.noun),
  ismAlet('İsm-i Âlet', FormCategoryType.noun),
  masdarMerre('Masdar Bina-i Merre', FormCategoryType.noun),
  masdarNev('Masdar Bina-i Nev’', FormCategoryType.noun),
  ismTasgir('İsm-i Tasğir', FormCategoryType.noun),
  ismMensub('İsm-i Mensub', FormCategoryType.noun),
  mubalagaIsmFail('Mübalağa İsm-i Fâil', FormCategoryType.noun),
  ismTafdil('İsm-i Tafdil', FormCategoryType.noun),
  fiilTaaccubEvvel('Fiil-i Taaccübü Evvel', FormCategoryType.verb),
  fiilTaaccubSani('Fiil-i Taaccübü Sânî', FormCategoryType.verb);

  const FormCategory(this.label, this.type);

  final String label;
  final FormCategoryType type;

  bool get isVerb => type == FormCategoryType.verb;
  bool get isNoun => type == FormCategoryType.noun;

  static FormCategory fromJson(String value) {
    return FormCategory.values.firstWhere((category) => category.name == value);
  }
}

enum FormCategoryType { verb, noun }

enum Voice {
  malum('Malum'),
  mechul('Meçhul');

  const Voice(this.label);

  final String label;

  static Voice fromJson(String value) {
    return Voice.values.firstWhere((voice) => voice.name == value);
  }
}

enum PronounKind {
  independent('Ayrı Zamirler'),
  attached('Bitişik Zamirler');

  const PronounKind(this.label);

  final String label;

  static PronounKind fromJson(String value) {
    return PronounKind.values.firstWhere((kind) => kind.name == value);
  }
}

enum FormPerson {
  first('1. şahıs'),
  second('2. şahıs'),
  third('3. şahıs'),
  none('şahıs yok');

  const FormPerson(this.label);

  final String label;

  static FormPerson fromJson(String value) {
    return FormPerson.values.firstWhere((person) => person.name == value);
  }
}

enum FormNumber {
  singular('tekil'),
  dual('ikil'),
  plural('çoğul');

  const FormNumber(this.label);

  final String label;

  static FormNumber fromJson(String value) {
    return FormNumber.values.firstWhere((number) => number.name == value);
  }
}

enum FormGender {
  masculine('müzekker'),
  feminine('müennes'),
  common('ortak');

  const FormGender(this.label);

  final String label;

  static FormGender fromJson(String value) {
    return FormGender.values.firstWhere((gender) => gender.name == value);
  }
}
