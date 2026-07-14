import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/presentation/organisms/recipe/recipe_ingredients_section.dart';

void main() {
  group('RecipeIngredientsSection Widget Tests', () {
    testWidgets(
      'Debe mostrar el título Ingredientes',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: RecipeIngredientsSection(
                ingredients: [],
              ),
            ),
          ),
        );

        expect(find.byType(RecipeIngredientsSection), findsOneWidget);
        expect(find.text('Ingredientes'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar todos los ingredientes',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: RecipeIngredientsSection(
                ingredients: [
                  '2 tazas de arroz',
                  '500 gramos de pollo',
                  '1 cebolla',
                ],
              ),
            ),
          ),
        );

        expect(find.text('2 tazas de arroz'), findsOneWidget);
        expect(find.text('500 gramos de pollo'), findsOneWidget);
        expect(find.text('1 cebolla'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar un icono circular por cada ingrediente',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: RecipeIngredientsSection(
                ingredients: [
                  'Arroz',
                  'Pollo',
                  'Cebolla',
                ],
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.circle), findsNWidgets(3));
      },
    );

    testWidgets(
      'No debe mostrar iconos circulares cuando la lista está vacía',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: RecipeIngredientsSection(
                ingredients: [],
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.circle), findsNothing);
        expect(find.text('Ingredientes'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mantener el orden de los ingredientes',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: RecipeIngredientsSection(
                ingredients: [
                  'Primero',
                  'Segundo',
                  'Tercero',
                ],
              ),
            ),
          ),
        );

        final firstPosition = tester.getTopLeft(
          find.text('Primero'),
        );

        final secondPosition = tester.getTopLeft(
          find.text('Segundo'),
        );

        final thirdPosition = tester.getTopLeft(
          find.text('Tercero'),
        );

        expect(firstPosition.dy, lessThan(secondPosition.dy));
        expect(secondPosition.dy, lessThan(thirdPosition.dy));
      },
    );
  });
}