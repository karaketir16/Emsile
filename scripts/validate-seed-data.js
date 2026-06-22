const fs = require('fs');
const path = require('path');

const dataDir = path.join(__dirname, '..', 'assets', 'data');
const catalogPath = path.join(dataDir, 'catalog.json');
const verbsDir = path.join(dataDir, 'verbs');
const validIbareFields = new Set([
  'structure',
  'wordForm',
  'root',
  'singular',
  'derivedFrom',
  'baseForm',
  'bab',
  'pattern',
  'morphology',
  'conjugation',
  'person',
  'hiddenPronoun',
  'pronoun',
  'referent',
  'transitivity',
  'presentForm',
  'middleRadical',
  'numberType',
  'tamyiz',
  'meaning',
  'turkish',
  'term',
  'effect',
  'syntax',
  'role',
  'construction',
  'noun',
  'nasb',
  'irab',
  'ellipsis',
]);
const validCategories = new Set([
  'mazi',
  'muzari',
  'masdar',
  'ismFail',
  'ismMeful',
  'cahdMutlak',
  'cahdMustagrak',
  'nefyHal',
  'nefyIstikbal',
  'tekidNefyIstikbal',
  'emrGaib',
  'nehyGaib',
  'emrHazir',
  'nehyHazir',
  'ismZamanMekan',
  'ismAlet',
  'masdarMerre',
  'masdarNev',
  'ismTasgir',
  'ismMensub',
  'mubalagaIsmFail',
  'ismTafdil',
  'fiilTaaccubEvvel',
  'fiilTaaccubSani',
]);
const validVoices = new Set(['malum', 'mechul']);
const validPronounKinds = new Set(['independent', 'attached']);
const validPersons = new Set(['first', 'second', 'third', 'none']);
const validNumbers = new Set(['singular', 'dual', 'plural']);
const validGenders = new Set(['masculine', 'feminine', 'common']);

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

function assertString(value, field) {
  assert(
    typeof value === 'string' && value.trim().length > 0,
    `${field} must be a non-empty string`,
  );
}

function validateLessons(lessons) {
  assert(Array.isArray(lessons), 'lessons must be an array');
  lessons.forEach((lesson, index) => {
    assert(
      Number.isInteger(lesson.order),
      `lessons[${index}].order must be an integer`,
    );
    assertString(lesson.title, `lessons[${index}].title`);
    assertString(lesson.summary, `lessons[${index}].summary`);
    assertString(lesson.rule, `lessons[${index}].rule`);
    assert(
      validCategories.has(lesson.relatedCategory),
      `lessons[${index}].relatedCategory is invalid`,
    );
  });
}

function validateVerbManifest(verbs) {
  assert(Array.isArray(verbs), 'verbs must be an array');
  verbs.forEach((verb, index) => {
    assertString(verb.id, `verbs[${index}].id`);
    assertString(verb.root, `verbs[${index}].root`);
    assertString(verb.title, `verbs[${index}].title`);
    assertString(verb.assetPath, `verbs[${index}].assetPath`);
    assertString(verb.group, `verbs[${index}].group`);
  });
}

function validateIbareManifest(books) {
  assert(Array.isArray(books), 'ibareBooks must be an array');
  books.forEach((book, index) => {
    assertString(book.id, `ibareBooks[${index}].id`);
    assertString(book.title, `ibareBooks[${index}].title`);
    assertString(book.assetPath, `ibareBooks[${index}].assetPath`);
  });
}

function validateIbareBook(bookPath, expectedId) {
  const book = JSON.parse(fs.readFileSync(bookPath, 'utf8'));
  assert(book.schemaVersion === 1, `${expectedId}.schemaVersion must be 1`);
  assert(book.id === expectedId, `${expectedId}.id must match manifest`);
  assertString(book.title, `${expectedId}.title`);
  assertString(book.shortTitle, `${expectedId}.shortTitle`);
  assertString(book.description, `${expectedId}.description`);
  assert(Array.isArray(book.passages), `${expectedId}.passages must be an array`);
  assert(book.passages.length > 0, `${expectedId}.passages must not be empty`);

  const passageIds = new Set();
  book.passages.forEach((passage, passageIndex) => {
    const prefix = `${expectedId}.passages[${passageIndex}]`;
    assertString(passage.id, `${prefix}.id`);
    assert(!passageIds.has(passage.id), `${prefix}.id must be unique`);
    passageIds.add(passage.id);
    assert(Number.isInteger(passage.order), `${prefix}.order must be an integer`);
    assertString(passage.title, `${prefix}.title`);
    assertString(passage.subtitle, `${prefix}.subtitle`);
    assertString(passage.translation, `${prefix}.translation`);
    assert(Array.isArray(passage.tokens), `${prefix}.tokens must be an array`);
    assert(passage.tokens.length > 0, `${prefix}.tokens must not be empty`);

    const tokenIds = new Set();
    passage.tokens.forEach((token, tokenIndex) => {
      const tokenPrefix = `${prefix}.tokens[${tokenIndex}]`;
      assertString(token.id, `${tokenPrefix}.id`);
      assert(!tokenIds.has(token.id), `${tokenPrefix}.id must be unique`);
      tokenIds.add(token.id);
      assertString(token.arabic, `${tokenPrefix}.arabic`);
      assertString(token.gloss, `${tokenPrefix}.gloss`);
      if (token.printedArabic != null) {
        assertString(token.printedArabic, `${tokenPrefix}.printedArabic`);
      }
      if (token.punctuation != null) {
        assert(
          typeof token.punctuation === 'string',
          `${tokenPrefix}.punctuation must be a string`,
        );
      }
      assert(
        token.analysis && typeof token.analysis === 'object',
        `${tokenPrefix}.analysis is required`,
      );
      assertString(token.analysis.kind, `${tokenPrefix}.analysis.kind`);

      const fields = token.analysis.fields ?? {};
      assert(
        fields && typeof fields === 'object' && !Array.isArray(fields),
        `${tokenPrefix}.analysis.fields must be an object`,
      );
      Object.entries(fields).forEach(([key, value]) => {
        assert(
          validIbareFields.has(key),
          `${tokenPrefix}.analysis.fields.${key} is invalid`,
        );
        assertString(value, `${tokenPrefix}.analysis.fields.${key}`);
      });

      const details = token.analysis.details ?? [];
      assert(Array.isArray(details), `${tokenPrefix}.analysis.details must be an array`);
      details.forEach((detail, detailIndex) => {
        assertString(
          detail.label,
          `${tokenPrefix}.analysis.details[${detailIndex}].label`,
        );
        assertString(
          detail.value,
          `${tokenPrefix}.analysis.details[${detailIndex}].value`,
        );
      });
    });
  });
}

function validatePronouns(pronouns) {
  assert(Array.isArray(pronouns), 'pronouns must be an array');
  assert(pronouns.length > 0, 'pronouns must not be empty');
  pronouns.forEach((pronoun, index) => {
    assert(
      validPronounKinds.has(pronoun.kind),
      `pronouns[${index}].kind is invalid`,
    );
    assert(
      validPersons.has(pronoun.person) && pronoun.person !== 'none',
      `pronouns[${index}].person is invalid`,
    );
    assert(
      validNumbers.has(pronoun.number),
      `pronouns[${index}].number is invalid`,
    );
    assert(
      validGenders.has(pronoun.gender),
      `pronouns[${index}].gender is invalid`,
    );
    assertString(pronoun.labelTr, `pronouns[${index}].labelTr`);
    assertString(pronoun.arabic, `pronouns[${index}].arabic`);
    assertString(pronoun.meaning, `pronouns[${index}].meaning`);
  });

  for (const kind of validPronounKinds) {
    assert(
      pronouns.filter((pronoun) => pronoun.kind === kind).length === 15,
      `pronouns must contain 15 ${kind} entries`,
    );
  }
}

function validateMuhtelifeEntries(entries, verbId) {
  assert(Array.isArray(entries), `${verbId}.muhtelifeEntries must be an array`);
  entries.forEach((entry, index) => {
    assertString(entry.type, `${verbId}.muhtelifeEntries[${index}].type`);
    assertString(entry.label, `${verbId}.muhtelifeEntries[${index}].label`);
    assertString(entry.arabic, `${verbId}.muhtelifeEntries[${index}].arabic`);
    assertString(entry.meaning, `${verbId}.muhtelifeEntries[${index}].meaning`);
    assert(
      Number.isInteger(entry.sortOrder),
      `${verbId}.muhtelifeEntries[${index}].sortOrder must be an integer`,
    );
    if (entry.row != null) {
      assert(
        Number.isInteger(entry.row),
        `${verbId}.muhtelifeEntries[${index}].row must be an integer`,
      );
    }
    if (entry.column != null) {
      assert(
        ['left', 'right'].includes(entry.column),
        `${verbId}.muhtelifeEntries[${index}].column must be left or right`,
      );
    }
  });
}

function validateMuttarideForms(forms, verbId) {
  assert(Array.isArray(forms), `${verbId}.muttarideForms must be an array`);
  forms.forEach((form, index) => {
    assert(
      validCategories.has(form.category),
      `${verbId}.muttarideForms[${index}].category is invalid`,
    );
    assert(
      validVoices.has(form.voice),
      `${verbId}.muttarideForms[${index}].voice is invalid`,
    );
    assert(
      validPersons.has(form.person),
      `${verbId}.muttarideForms[${index}].person is invalid`,
    );
    assert(
      validNumbers.has(form.number),
      `${verbId}.muttarideForms[${index}].number is invalid`,
    );
    assert(
      validGenders.has(form.gender),
      `${verbId}.muttarideForms[${index}].gender is invalid`,
    );
    assertString(
      form.pronounLabel,
      `${verbId}.muttarideForms[${index}].pronounLabel`,
    );
    assertString(form.arabic, `${verbId}.muttarideForms[${index}].arabic`);
    assertString(form.meaning, `${verbId}.muttarideForms[${index}].meaning`);
  });
}

function validateConjugationSource(source, verbId) {
  assert(source && typeof source === 'object', `${verbId}.conjugationSource is required`);
  assertString(source.strategy, `${verbId}.conjugationSource.strategy`);

  if (source.strategy === 'generated') {
    assert(
      source.generated && typeof source.generated === 'object',
      `${verbId}.conjugationSource.generated is required`,
    );
    assertString(
      source.generated.family,
      `${verbId}.conjugationSource.generated.family`,
    );
    assertString(
      source.generated.verbClass,
      `${verbId}.conjugationSource.generated.verbClass`,
    );
    assertString(source.generated.bab, `${verbId}.conjugationSource.generated.bab`);
    assert(
      source.generated.lemma && typeof source.generated.lemma === 'object',
      `${verbId}.conjugationSource.generated.lemma is required`,
    );
    assertString(
      source.generated.lemma.mazi,
      `${verbId}.conjugationSource.generated.lemma.mazi`,
    );
    assertString(
      source.generated.lemma.muzari,
      `${verbId}.conjugationSource.generated.lemma.muzari`,
    );
  }
}

function validateVerbEntry(verbPath) {
  const entry = JSON.parse(fs.readFileSync(verbPath, 'utf8'));
  const verbId = entry.meta?.id ?? path.basename(verbPath, '.json');

  assert(entry.meta && typeof entry.meta === 'object', `${verbId}.meta is required`);
  assertString(entry.meta.id, `${verbId}.meta.id`);
  assertString(entry.meta.root, `${verbId}.meta.root`);
  assert(Array.isArray(entry.meta.letters), `${verbId}.meta.letters must be an array`);
  assert(entry.meta.letters.length === 3, `${verbId}.meta.letters must contain 3 letters`);
  entry.meta.letters.forEach((letter, index) => {
    assertString(letter, `${verbId}.meta.letters[${index}]`);
  });
  assertString(entry.meta.title, `${verbId}.meta.title`);
  assertString(entry.meta.transliteration, `${verbId}.meta.transliteration`);
  assertString(entry.meta.meaningSummary, `${verbId}.meta.meaningSummary`);
  assertString(entry.meta.group, `${verbId}.meta.group`);

  validateMuhtelifeEntries(entry.muhtelifeEntries, verbId);

  const hasForms = Array.isArray(entry.muttarideForms) && entry.muttarideForms.length > 0;
  const hasSource = entry.conjugationSource != null;
  assert(
    hasForms || hasSource,
    `${verbId} must define muttarideForms or conjugationSource`,
  );

  if (hasForms) {
    validateMuttarideForms(entry.muttarideForms, verbId);
  }
  if (hasSource) {
    validateConjugationSource(entry.conjugationSource, verbId);
  }
}

function main() {
  const catalog = JSON.parse(fs.readFileSync(catalogPath, 'utf8'));

  assert(Number.isInteger(catalog.version), 'catalog.version must be an integer');
  assertString(catalog.defaultVerbId, 'catalog.defaultVerbId');
  validateLessons(catalog.lessons);
  validatePronouns(catalog.pronouns);
  validateVerbManifest(catalog.verbs);
  validateIbareManifest(catalog.ibareBooks ?? []);

  const knownVerbIds = new Set(catalog.verbs.map((verb) => verb.id));
  assert(
    knownVerbIds.has(catalog.defaultVerbId),
    'catalog.defaultVerbId must exist in catalog.verbs',
  );

  const verbFiles = fs
    .readdirSync(verbsDir)
    .filter((file) => file.endsWith('.json'))
    .map((file) => path.join(verbsDir, file));

  assert(verbFiles.length > 0, 'verbs directory must contain at least one json file');
  verbFiles.forEach(validateVerbEntry);

  catalog.verbs.forEach((verb, index) => {
    const assetPath = path.join(__dirname, '..', verb.assetPath);
    assert(fs.existsSync(assetPath), `verbs[${index}].assetPath does not exist`);
  });

  (catalog.ibareBooks ?? []).forEach((book, index) => {
    const assetPath = path.join(__dirname, '..', book.assetPath);
    assert(
      fs.existsSync(assetPath),
      `ibareBooks[${index}].assetPath does not exist`,
    );
    validateIbareBook(assetPath, book.id);
  });

  console.log('Seed data valid');
}

try {
  main();
} catch (error) {
  console.error(error.message);
  process.exit(1);
}
