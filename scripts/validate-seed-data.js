const fs = require('fs');
const path = require('path');

const dataDir = path.join(__dirname, '..', 'assets', 'data');
const catalogPath = path.join(dataDir, 'catalog.json');
const verbsDir = path.join(dataDir, 'verbs');
const validCategories = new Set(['mazi', 'muzari']);
const validVoices = new Set(['malum', 'mechul']);

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
      ['first', 'second', 'third'].includes(form.person),
      `${verbId}.muttarideForms[${index}].person is invalid`,
    );
    assert(
      ['singular', 'dual', 'plural'].includes(form.number),
      `${verbId}.muttarideForms[${index}].number is invalid`,
    );
    assert(
      ['masculine', 'feminine', 'common'].includes(form.gender),
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
  validateVerbManifest(catalog.verbs);

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

  console.log('Seed data valid');
}

try {
  main();
} catch (error) {
  console.error(error.message);
  process.exit(1);
}
