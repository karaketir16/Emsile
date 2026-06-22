import 'package:emsile_flutter/data/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses fields and sorts passages by order', () {
    final book = IbareBook.fromJson(
      _bookJson([
        _passageJson(id: 'second', order: 2),
        _passageJson(id: 'first', order: 1),
      ]),
    );

    expect(book.passages.map((passage) => passage.id), ['first', 'second']);
    expect(book.passages.first.tokens.single.fields[IbareField.root], 'ف ع ل');
  });

  test('rejects unknown analysis fields', () {
    final token = _tokenJson();
    (token['analysis'] as Map<String, dynamic>)['fields'] = {
      'unknown': 'value',
    };

    expect(
      () => IbareBook.fromJson(
        _bookJson([_passageJson(id: 'first', order: 1, token: token)]),
      ),
      throwsFormatException,
    );
  });

  test('rejects duplicate passage and token ids', () {
    expect(
      () => IbareBook.fromJson(
        _bookJson([
          _passageJson(id: 'same', order: 1),
          _passageJson(id: 'same', order: 2),
        ]),
      ),
      throwsFormatException,
    );

    final passage = _passageJson(id: 'first', order: 1);
    passage['tokens'] = [_tokenJson(), _tokenJson()];
    expect(
      () => IbareBook.fromJson(_bookJson([passage])),
      throwsFormatException,
    );
  });
}

Map<String, dynamic> _bookJson(List<Map<String, dynamic>> passages) => {
  'schemaVersion': 1,
  'id': 'book',
  'title': 'Book',
  'shortTitle': 'Book',
  'description': 'Description',
  'passages': passages,
};

Map<String, dynamic> _passageJson({
  required String id,
  required int order,
  Map<String, dynamic>? token,
}) => {
  'id': id,
  'order': order,
  'title': id,
  'subtitle': id,
  'translation': id,
  'tokens': [token ?? _tokenJson()],
};

Map<String, dynamic> _tokenJson() => {
  'id': 'token',
  'arabic': 'فَعَلَ',
  'gloss': 'Yaptı',
  'analysis': {
    'kind': 'Fiil',
    'fields': {'root': 'ف ع ل'},
  },
};
