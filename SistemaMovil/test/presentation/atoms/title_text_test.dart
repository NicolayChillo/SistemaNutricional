import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/atoms/title_text.dart';
import '../../../lib/presentation/theme/app_colors.dart';

void main() {
  group('TitleText Widget Tests', () {
    testWidgets(
      'Debe mostrar correctamente el título',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TitleText(
                text: 'Mi título principal',
              ),
            ),
          ),
        );

        expect(find.text('Mi título principal'), findsOneWidget);
        expect(find.byType(TitleText), findsOneWidget);
      },
    );

    testWidgets(
      'Debe aplicar correctamente la alineación',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TitleText(
                text: 'Título centrado',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );

        final Text textWidget = tester.widget<Text>(
          find.text('Título centrado'),
        );

        expect(textWidget.textAlign, TextAlign.center);
      },
    );

    testWidgets(
      'Debe aplicar un color personalizado',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TitleText(
                text: 'Título personalizado',
                color: Colors.green,
              ),
            ),
          ),
        );

        final Text textWidget = tester.widget<Text>(
          find.text('Título personalizado'),
        );

        expect(textWidget.style?.color, Colors.green);
      },
    );

    testWidgets(
      'Debe utilizar el color primario por defecto',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TitleText(
                text: 'Título por defecto',
              ),
            ),
          ),
        );

        final Text textWidget = tester.widget<Text>(
          find.text('Título por defecto'),
        );

        expect(
          textWidget.style?.color,
          AppColors.textPrimary,
        );
      },
    );
  });
}