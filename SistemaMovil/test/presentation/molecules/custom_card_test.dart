import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/molecules/custom_card.dart';

void main() {
  group('CustomCard Widget Tests', () {
    testWidgets(
      'Debe mostrar correctamente el widget hijo',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CustomCard(
                child: Text('Contenido de prueba'),
              ),
            ),
          ),
        );

        expect(find.byType(CustomCard), findsOneWidget);
        expect(find.byType(Card), findsOneWidget);
        expect(find.text('Contenido de prueba'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe ejecutar onTap cuando se presiona la tarjeta',
      (WidgetTester tester) async {
        bool fuePresionado = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomCard(
                onTap: () {
                  fuePresionado = true;
                },
                child: const Text('Presionar'),
              ),
            ),
          ),
        );

        await tester.tap(find.byType(InkWell));
        await tester.pump();

        expect(fuePresionado, isTrue);
      },
    );

    testWidgets(
  'Debe utilizar padding por defecto de 16',
  (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomCard(
            child: Text('Contenido'),
          ),
        ),
      ),
    );

    final paddingFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Padding &&
          widget.padding == const EdgeInsets.all(16),
    );

    expect(paddingFinder, findsOneWidget);
  },
);

    testWidgets(
  'Debe aplicar padding personalizado',
  (WidgetTester tester) async {
    const customPadding = EdgeInsets.all(32);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CustomCard(
            padding: customPadding,
            child: Text('Contenido'),
          ),
        ),
      ),
    );

    final paddingFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Padding &&
          widget.padding == customPadding,
    );

    expect(paddingFinder, findsOneWidget);
  },
);

    testWidgets(
      'Debe tener elevación de 2 y color blanco',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CustomCard(
                child: Text('Contenido'),
              ),
            ),
          ),
        );

        final Card card = tester.widget<Card>(
          find.byType(Card),
        );

        expect(card.elevation, 2);
        expect(card.color, Colors.white);
      },
    );
  });
}