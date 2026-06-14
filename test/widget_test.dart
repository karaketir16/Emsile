import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:emsile_flutter/main.dart';

void main() {
  testWidgets('shows the Emsile home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const EmsileApp());

    expect(find.text('Emsile'), findsOneWidget);
    expect(find.text('Bugünkü Akış'), findsOneWidget);
    expect(find.text('نَصَرَ'), findsOneWidget);
  });

  testWidgets('opens the conjugation screen from bottom navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EmsileApp());

    await tester.tap(find.text('Tablo'));
    await tester.pump();

    expect(find.text('Çekim Tablosu'), findsOneWidget);
    expect(find.text('Mâzi'), findsOneWidget);
    expect(find.text('Malum'), findsOneWidget);
  });

  testWidgets('renders key screens at mobile width', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const EmsileApp());
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Tablo'));
    await tester.pump();
    expect(find.text('Çekim Tablosu'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Pratik'));
    await tester.pump();
    expect(find.text('Formu gör, anlamı hatırla.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
