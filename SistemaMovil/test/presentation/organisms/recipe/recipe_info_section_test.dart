import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/domain/entities/recipe.dart';
import '../../../../lib/presentation/organisms/recipe/recipe_info_section.dart';

void main() {
  Recipe createTestRecipe({
    String title = 'Arroz con pollo',
    String description = 'Una receta deliciosa',
    int preparationTime = 30,
    int servings = 4,
    String category = 'Almuerzo',
  }) {
    return Recipe(
      id: 'recipe-1',
      title: title,
      description: description,
      imageUrl: '',
      ingredients: const ['Arroz', 'Pollo'],
      steps: const ['Cocinar', 'Servir'],
      userId: 'user-1',
      createdAt: DateTime(2026, 7, 14),
      preparationTime: preparationTime,
      servings: servings,
      category: category,
    );
  }

  group('RecipeInfoSection Widget Tests', () {
    testWidgets(
      'Debe mostrar título y descripción',
      (WidgetTester tester) async {
        final recipe = createTestRecipe();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeInfoSection(recipe: recipe),
            ),
          ),
        );

        expect(find.text('Arroz con pollo'), findsOneWidget);
        expect(find.text('Una receta deliciosa'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar tiempo de preparación',
      (WidgetTester tester) async {
        final recipe = createTestRecipe(
          preparationTime: 45,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeInfoSection(recipe: recipe),
            ),
          ),
        );

        expect(find.text('45 min'), findsOneWidget);
        expect(find.byIcon(Icons.timer), findsOneWidget);
      },
    );

    testWidgets(
  'Debe mostrar correctamente varias porciones',
  (WidgetTester tester) async {
    final recipe = createTestRecipe(
      servings: 4,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RecipeInfoSection(recipe: recipe),
        ),
      ),
    );

    expect(find.text('4 porciónes'), findsOneWidget);
    expect(find.byIcon(Icons.people), findsOneWidget);
  },
);

    testWidgets(
      'Debe mostrar porción en singular cuando servings es 1',
      (WidgetTester tester) async {
        final recipe = createTestRecipe(
          servings: 1,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeInfoSection(recipe: recipe),
            ),
          ),
        );

        expect(find.text('1 porción'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar categoría cuando no está vacía',
      (WidgetTester tester) async {
        final recipe = createTestRecipe(
          category: 'Cena',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeInfoSection(recipe: recipe),
            ),
          ),
        );

        expect(find.text('Cena'), findsOneWidget);
        expect(find.byIcon(Icons.category), findsOneWidget);
      },
    );

    testWidgets(
      'No debe mostrar chips cuando los datos opcionales están vacíos',
      (WidgetTester tester) async {
        final recipe = createTestRecipe(
          preparationTime: 0,
          servings: 0,
          category: '',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeInfoSection(recipe: recipe),
            ),
          ),
        );

        expect(find.byType(Chip), findsNothing);
        expect(find.byIcon(Icons.timer), findsNothing);
        expect(find.byIcon(Icons.people), findsNothing);
        expect(find.byIcon(Icons.category), findsNothing);
      },
    );

    testWidgets(
      'Debe mostrar tres chips cuando todos los datos están presentes',
      (WidgetTester tester) async {
        final recipe = createTestRecipe();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeInfoSection(recipe: recipe),
            ),
          ),
        );

        expect(find.byType(Chip), findsNWidgets(3));
      },
    );
  });
}