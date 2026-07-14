import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/atoms/circle_icon.dart';
import '../../../lib/presentation/theme/app_colors.dart';

void main() {
  group('CircleIcon Widget Tests', () {
    testWidgets(
      'Debe mostrar correctamente el icono',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CircleIcon(
                icon: Icons.person,
              ),
            ),
          ),
        );

        expect(find.byType(CircleIcon), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
      },
    );

    testWidgets(
      'Debe usar el tamaño por defecto de 80',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CircleIcon(
                icon: Icons.home,
              ),
            ),
          ),
        );

        final Container container = tester.widget<Container>(
          find.descendant(
            of: find.byType(CircleIcon),
            matching: find.byType(Container),
          ),
        );

        expect(container.constraints?.maxWidth, 80);
        expect(container.constraints?.maxHeight, 80);
      },
    );

    testWidgets(
      'Debe aplicar tamaño y colores personalizados',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CircleIcon(
                icon: Icons.star,
                size: 100,
                color: Colors.red,
                backgroundColor: Colors.yellow,
              ),
            ),
          ),
        );

        final Icon iconWidget = tester.widget<Icon>(
          find.byIcon(Icons.star),
        );

        final Container container = tester.widget<Container>(
          find.descendant(
            of: find.byType(CircleIcon),
            matching: find.byType(Container),
          ),
        );

        final BoxDecoration decoration =
            container.decoration as BoxDecoration;

        expect(iconWidget.size, 50);
        expect(iconWidget.color, Colors.red);
        expect(container.constraints?.maxWidth, 100);
        expect(container.constraints?.maxHeight, 100);
        expect(decoration.color, Colors.yellow);
        expect(decoration.shape, BoxShape.circle);
      },
    );

    testWidgets(
      'Debe utilizar hunterGreen como color por defecto del icono',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CircleIcon(
                icon: Icons.favorite,
              ),
            ),
          ),
        );

        final Icon iconWidget = tester.widget<Icon>(
          find.byIcon(Icons.favorite),
        );

        expect(iconWidget.color, AppColors.hunterGreen);
        expect(iconWidget.size, 40);
      },
    );
  });
}