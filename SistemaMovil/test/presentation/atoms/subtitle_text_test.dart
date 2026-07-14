import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/atoms/subtitle_text.dart';
import '../../../lib/presentation/theme/app_colors.dart';

void main() {
  group('SubtitleText Widget Tests', () {
    testWidgets(
      'Debe mostrar correctamente el subtítulo',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SubtitleText(
                text: 'Mi subtítulo',
              ),
            ),
          ),
        );

        expect(find.text('Mi subtítulo'), findsOneWidget);
        expect(find.byType(SubtitleText), findsOneWidget);
      },
    );

    testWidgets(
      'Debe aplicar correctamente la alineación',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SubtitleText(
                text: 'Subtítulo centrado',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );

        final Text textWidget = tester.widget<Text>(
          find.text('Subtítulo centrado'),
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
              body: SubtitleText(
                text: 'Subtítulo personalizado',
                color: Colors.blue,
              ),
            ),
          ),
        );

        final Text textWidget = tester.widget<Text>(
          find.text('Subtítulo personalizado'),
        );

        expect(textWidget.style?.color, Colors.blue);
      },
    );

    testWidgets(
      'Debe utilizar el color secundario por defecto',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SubtitleText(
                text: 'Subtítulo por defecto',
              ),
            ),
          ),
        );

        final Text textWidget = tester.widget<Text>(
          find.text('Subtítulo por defecto'),
        );

        expect(
          textWidget.style?.color,
          AppColors.textSecondary,
        );
      },
    );
  });
}