import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/atoms/body_text.dart';
import '../../../lib/presentation/molecules/divider_with_text.dart';
import '../../../lib/presentation/theme/app_colors.dart';

void main() {
  group('DividerWithText Widget Tests', () {
    testWidgets(
      'Debe mostrar correctamente el texto',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: DividerWithText(
                text: 'O continúa con',
              ),
            ),
          ),
        );

        expect(find.byType(DividerWithText), findsOneWidget);
        expect(find.text('O continúa con'), findsOneWidget);
        expect(find.byType(BodyText), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar exactamente dos divisores',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: DividerWithText(
                text: 'O',
              ),
            ),
          ),
        );

        expect(find.byType(Divider), findsNWidgets(2));
      },
    );

    testWidgets(
      'Debe contener dos widgets Expanded',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: DividerWithText(
                text: 'O',
              ),
            ),
          ),
        );

        expect(find.byType(Expanded), findsNWidgets(2));
      },
    );

    testWidgets(
      'Los divisores deben utilizar el color drySage',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: DividerWithText(
                text: 'O',
              ),
            ),
          ),
        );

        final Iterable<Divider> dividers =
            tester.widgetList<Divider>(find.byType(Divider));

        for (final divider in dividers) {
          expect(divider.color, AppColors.drySage);
        }
      },
    );

    testWidgets(
      'El BodyText debe utilizar textLight',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: DividerWithText(
                text: 'Separador',
              ),
            ),
          ),
        );

        final BodyText bodyText = tester.widget<BodyText>(
          find.byType(BodyText),
        );

        expect(bodyText.text, 'Separador');
        expect(bodyText.color, AppColors.textLight);
      },
    );
  });
}