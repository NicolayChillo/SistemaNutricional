import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/presentation/organisms/recipe/recipe_ingredients_form_section.dart';

void main() {
  group('RecipeIngredientsFormSection Widget Tests', () {
    testWidgets(
      'Debe mostrar el título Ingredientes',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeIngredientsFormSection(
                controllers: [],
                onAdd: () {},
                onRemove: (_) {},
              ),
            ),
          ),
        );

        expect(
          find.byType(RecipeIngredientsFormSection),
          findsOneWidget,
        );

        expect(find.text('Ingredientes'), findsOneWidget);
        expect(find.byIcon(Icons.add_circle), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar un campo por cada controller',
      (WidgetTester tester) async {
        final controllers = [
          TextEditingController(),
          TextEditingController(),
          TextEditingController(),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeIngredientsFormSection(
                controllers: controllers,
                onAdd: () {},
                onRemove: (_) {},
              ),
            ),
          ),
        );

        expect(find.byType(TextFormField), findsNWidgets(3));
        expect(find.text('Ingrediente 1'), findsOneWidget);
        expect(find.text('Ingrediente 2'), findsOneWidget);
        expect(find.text('Ingrediente 3'), findsOneWidget);

        for (final controller in controllers) {
          controller.dispose();
        }
      },
    );

    testWidgets(
      'Debe ejecutar onAdd al presionar agregar',
      (WidgetTester tester) async {
        bool fueAgregado = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeIngredientsFormSection(
                controllers: const [],
                onAdd: () {
                  fueAgregado = true;
                },
                onRemove: (_) {},
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.add_circle));
        await tester.pump();

        expect(fueAgregado, isTrue);
      },
    );

    testWidgets(
      'Debe ejecutar onRemove con el índice correcto',
      (WidgetTester tester) async {
        final controllers = [
          TextEditingController(),
          TextEditingController(),
          TextEditingController(),
        ];

        int? removedIndex;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeIngredientsFormSection(
                controllers: controllers,
                onAdd: () {},
                onRemove: (index) {
                  removedIndex = index;
                },
              ),
            ),
          ),
        );

        await tester.tap(
          find.byIcon(Icons.remove_circle).at(1),
        );
        await tester.pump();

        expect(removedIndex, 1);

        for (final controller in controllers) {
          controller.dispose();
        }
      },
    );

    testWidgets(
      'Debe actualizar el controller al escribir un ingrediente',
      (WidgetTester tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeIngredientsFormSection(
                controllers: [controller],
                onAdd: () {},
                onRemove: (_) {},
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byType(TextFormField),
          '500 gramos de pollo',
        );

        expect(
          controller.text,
          '500 gramos de pollo',
        );

        controller.dispose();
      },
    );

    testWidgets(
      'Debe mostrar un botón eliminar por cada ingrediente',
      (WidgetTester tester) async {
        final controllers = [
          TextEditingController(),
          TextEditingController(),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeIngredientsFormSection(
                controllers: controllers,
                onAdd: () {},
                onRemove: (_) {},
              ),
            ),
          ),
        );

        expect(
          find.byIcon(Icons.remove_circle),
          findsNWidgets(2),
        );

        for (final controller in controllers) {
          controller.dispose();
        }
      },
    );
  });
}