import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/presentation/organisms/recipe/recipe_steps_section.dart';

void main() {
  group('RecipeStepsSection Widget Tests', () {
    testWidgets(
      'Debe mostrar el título Preparación',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: RecipeStepsSection(
                steps: [],
              ),
            ),
          ),
        );

        expect(find.byType(RecipeStepsSection), findsOneWidget);
        expect(find.text('Preparación'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar todos los pasos',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: RecipeStepsSection(
                steps: [
                  'Lavar los ingredientes',
                  'Cocinar durante 30 minutos',
                  'Servir caliente',
                ],
              ),
            ),
          ),
        );

        expect(
          find.text('Lavar los ingredientes'),
          findsOneWidget,
        );

        expect(
          find.text('Cocinar durante 30 minutos'),
          findsOneWidget,
        );

        expect(
          find.text('Servir caliente'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe numerar los pasos desde 1',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: RecipeStepsSection(
                steps: [
                  'Paso uno',
                  'Paso dos',
                  'Paso tres',
                ],
              ),
            ),
          ),
        );

        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar un CircleAvatar por cada paso',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: RecipeStepsSection(
                steps: [
                  'Paso uno',
                  'Paso dos',
                  'Paso tres',
                ],
              ),
            ),
          ),
        );

        expect(find.byType(CircleAvatar), findsNWidgets(3));
      },
    );

    testWidgets(
      'No debe mostrar CircleAvatar cuando no existen pasos',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: RecipeStepsSection(
                steps: [],
              ),
            ),
          ),
        );

        expect(find.byType(CircleAvatar), findsNothing);
        expect(find.text('Preparación'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mantener el orden de los pasos',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: RecipeStepsSection(
                steps: [
                  'Primer paso',
                  'Segundo paso',
                  'Tercer paso',
                ],
              ),
            ),
          ),
        );

        final firstPosition = tester.getTopLeft(
          find.text('Primer paso'),
        );

        final secondPosition = tester.getTopLeft(
          find.text('Segundo paso'),
        );

        final thirdPosition = tester.getTopLeft(
          find.text('Tercer paso'),
        );

        expect(firstPosition.dy, lessThan(secondPosition.dy));
        expect(secondPosition.dy, lessThan(thirdPosition.dy));
      },
    );
  });
}