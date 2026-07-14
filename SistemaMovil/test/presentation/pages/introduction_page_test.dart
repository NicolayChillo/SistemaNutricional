import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../lib/presentation/pages/introduction_page.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createTestWidget() {
    return MaterialApp(
      routes: {
        '/login': (context) => const Scaffold(
              body: Text('Pantalla Login'),
            ),
      },
      home: const IntroductionPage(),
    );
  }

  group('IntroductionPage Widget Tests', () {
    testWidgets(
      'Debe mostrar correctamente la primera página de introducción',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(
          find.text('Bienvenido a NutriCalendar'),
          findsOneWidget,
        );

        expect(
          find.text(
            'Tu aplicación completa para gestionar recetas saludables y planificar tus comidas semanales.',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe mostrar el botón Saltar',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('Saltar'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar el botón para avanzar',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      },
    );

    testWidgets(
      'Debe navegar entre las páginas de introducción',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.arrow_forward));
        await tester.pumpAndSettle();

        expect(
          find.text('Gestiona tus Recetas'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe mostrar la segunda página con su descripción',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.arrow_forward));
        await tester.pumpAndSettle();

        expect(
          find.text(
            'Crea, edita y organiza tus recetas favoritas. Sube imágenes, añade ingredientes y pasos de preparación.',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe guardar introduction_completed al presionar Saltar',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Saltar'));
        await tester.pumpAndSettle();

        final prefs = await SharedPreferences.getInstance();

        expect(
          prefs.getBool('introduction_completed'),
          isTrue,
        );
      },
    );

    testWidgets(
      'Debe navegar al login al presionar Saltar',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Saltar'));
        await tester.pumpAndSettle();

        expect(find.text('Pantalla Login'), findsOneWidget);
      },
    );
  });
}