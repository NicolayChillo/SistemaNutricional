import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/atoms/body_text.dart';
import '../../../lib/presentation/theme/app_colors.dart';

void main() {
  group('BodyText Widget Tests', () {
    testWidgets(
      'Debe mostrar correctamente el texto',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: BodyText(
                text: 'Este es un texto de prueba',
              ),
            ),
          ),
        );

        expect(
          find.text('Este es un texto de prueba'),
          findsOneWidget,
        );
        expect(find.byType(BodyText), findsOneWidget);
      },
    );

    testWidgets(
      'Debe aplicar correctamente la alineación',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: BodyText(
                text: 'Texto centrado',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );

        final Text textWidget = tester.widget<Text>(
          find.text('Texto centrado'),
        );

        expect(textWidget.textAlign, TextAlign.center);
      },
    );

    testWidgets(
      'Debe aplicar el color personalizado',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: BodyText(
                text: 'Texto personalizado',
                color: Colors.red,
              ),
            ),
          ),
        );

        final Text textWidget = tester.widget<Text>(
          find.text('Texto personalizado'),
        );

        expect(textWidget.style?.color, Colors.red);
      },
    );

    testWidgets(
      'Debe usar el color secundario por defecto',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: BodyText(
                text: 'Texto por defecto',
              ),
            ),
          ),
        );

        final Text textWidget = tester.widget<Text>(
          find.text('Texto por defecto'),
        );

        expect(
          textWidget.style?.color,
          AppColors.textSecondary,
        );
      },
    );

    testWidgets(
      'Debe aplicar correctamente el peso de fuente',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: BodyText(
                text: 'Texto en negrita',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );

        final Text textWidget = tester.widget<Text>(
          find.text('Texto en negrita'),
        );

        expect(
          textWidget.style?.fontWeight,
          FontWeight.bold,
        );
      },
    );
  });
}