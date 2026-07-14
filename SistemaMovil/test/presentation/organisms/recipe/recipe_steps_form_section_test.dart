import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/presentation/organisms/recipe/recipe_steps_form_section.dart';

void main() {
  group('RecipeStepsFormSection Widget Tests', () {
    testWidgets(
      'Debe mostrar el título Pasos',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeStepsFormSection(
                controllers: [],
                onAdd: () {},
                onRemove: (_) {},
              ),
            ),
          ),
        );

        expect(
          find.byType(RecipeStepsFormSection),
          findsOneWidget,
        );

        expect(find.text('Pasos'), findsOneWidget);
        expect(find.byIcon(Icons.add_circle), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar un campo por cada paso',
      (WidgetTester tester) async {
        final controllers = [
          TextEditingController(),
          TextEditingController(),
          TextEditingController(),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeStepsFormSection(
                controllers: controllers,
                onAdd: () {},
                onRemove: (_) {},
              ),
            ),
          ),
        );

        expect(find.byType(TextFormField), findsNWidgets(3));
        expect(find.text('Paso 1'), findsOneWidget);
        expect(find.text('Paso 2'), findsOneWidget);
        expect(find.text('Paso 3'), findsOneWidget);

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
              body: RecipeStepsFormSection(
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
              body: RecipeStepsFormSection(
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
          find.byIcon(Icons.remove_circle).at(2),
        );
        await tester.pump();

        expect(removedIndex, 2);

        for (final controller in controllers) {
          controller.dispose();
        }
      },
    );

    testWidgets(
      'Debe actualizar el controller al escribir un paso',
      (WidgetTester tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeStepsFormSection(
                controllers: [controller],
                onAdd: () {},
                onRemove: (_) {},
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byType(TextFormField),
          'Cocinar durante 30 minutos',
        );

        expect(
          controller.text,
          'Cocinar durante 30 minutos',
        );

        controller.dispose();
      },
    );

    testWidgets(
  'Cada campo de paso debe permitir dos líneas',
  (WidgetTester tester) async {
    final controllers = [
      TextEditingController(),
      TextEditingController(),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RecipeStepsFormSection(
            controllers: controllers,
            onAdd: () {},
            onRemove: (_) {},
          ),
        ),
      ),
    );

    final fields = tester.widgetList<EditableText>(
      find.byType(EditableText),
    );

    expect(fields.length, 2);

    for (final field in fields) {
      expect(field.maxLines, 2);
    }

    for (final controller in controllers) {
      controller.dispose();
    }
  },
);


  });
}