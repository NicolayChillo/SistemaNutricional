import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/atoms/secondary_button.dart';

void main() {
  group('SecondaryButton Widget Tests', () {
    testWidgets(
      'Debe mostrar correctamente el texto del botón',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SecondaryButton(
                text: 'Cancelar',
              ),
            ),
          ),
        );

        expect(find.byType(SecondaryButton), findsOneWidget);
        expect(find.byType(OutlinedButton), findsOneWidget);
        expect(find.text('Cancelar'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe ejecutar onPressed al presionar el botón',
      (WidgetTester tester) async {
        bool fuePresionado = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SecondaryButton(
                text: 'Continuar',
                onPressed: () {
                  fuePresionado = true;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(OutlinedButton));
        await tester.pump();

        expect(fuePresionado, isTrue);
      },
    );

    testWidgets(
      'Debe mostrar indicador de carga cuando isLoading es true',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SecondaryButton(
                text: 'Cargando',
                isLoading: true,
              ),
            ),
          ),
        );

        expect(
          find.byType(CircularProgressIndicator),
          findsOneWidget,
        );

        expect(find.text('Cargando'), findsNothing);
      },
    );

    testWidgets(
      'No debe ejecutar onPressed mientras está cargando',
      (WidgetTester tester) async {
        bool fuePresionado = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SecondaryButton(
                text: 'Cargando',
                isLoading: true,
                onPressed: () {
                  fuePresionado = true;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(OutlinedButton));
        await tester.pump();

        expect(fuePresionado, isFalse);
      },
    );

    testWidgets(
      'Debe mostrar icono y texto cuando se proporciona un icono',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SecondaryButton(
                text: 'Regresar',
                icon: Icons.arrow_back,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        expect(find.text('Regresar'), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
      },
    );
  });
}