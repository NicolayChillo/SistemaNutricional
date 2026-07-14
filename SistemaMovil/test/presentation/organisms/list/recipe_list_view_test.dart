import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/domain/entities/recipe.dart';
import '../../../../lib/presentation/organisms/lists/recipe_list_view.dart';
import '../../../../lib/presentation/organisms/recipe/recipe_card.dart';

void main() {
  Recipe createRecipe({
    required String id,
    required String title,
  }) {
    return Recipe(
      id: id,
      title: title,
      description: 'Descripción de $title',
      imageUrl: '',
      ingredients: const ['Ingrediente'],
      steps: const ['Paso'],
      userId: 'user-1',
      createdAt: DateTime(2026, 7, 14),
      preparationTime: 30,
      servings: 2,
      category: 'Almuerzo',
    );
  }

  Widget createWidget({
    required List<Recipe> recipes,
    required Function(Recipe) onRecipeTap,
    Future<void> Function()? onRefresh,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: RecipeListView(
          recipes: recipes,
          onRecipeTap: onRecipeTap,
          onRefresh: onRefresh,
        ),
      ),
    );
  }

  group('RecipeListView Widget Tests', () {
    testWidgets(
      'Debe mostrar mensaje cuando la lista está vacía',
      (tester) async {
        await tester.pumpWidget(
          createWidget(
            recipes: [],
            onRecipeTap: (_) {},
          ),
        );

        expect(find.text('No hay recetas todavía'), findsOneWidget);
        expect(
          find.text('Toca el botón + para agregar una'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar una RecipeCard por cada receta',
      (tester) async {
        final recipes = [
          createRecipe(id: '1', title: 'Receta uno'),
          createRecipe(id: '2', title: 'Receta dos'),
          createRecipe(id: '3', title: 'Receta tres'),
        ];

        await tester.pumpWidget(
          createWidget(
            recipes: recipes,
            onRecipeTap: (_) {},
          ),
        );

        expect(find.byType(RecipeCard), findsNWidgets(3));
      },
    );

    testWidgets(
      'Debe mostrar los títulos de las recetas',
      (tester) async {
        final recipes = [
          createRecipe(id: '1', title: 'Pizza'),
          createRecipe(id: '2', title: 'Hamburguesa'),
        ];

        await tester.pumpWidget(
          createWidget(
            recipes: recipes,
            onRecipeTap: (_) {},
          ),
        );

        expect(find.text('Pizza'), findsOneWidget);
        expect(find.text('Hamburguesa'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe ejecutar onRecipeTap con la receta correcta',
      (tester) async {
        final recipe = createRecipe(
          id: '123',
          title: 'Receta seleccionada',
        );

        Recipe? selectedRecipe;

        await tester.pumpWidget(
          createWidget(
            recipes: [recipe],
            onRecipeTap: (selected) {
              selectedRecipe = selected;
            },
          ),
        );

        await tester.tap(find.byType(RecipeCard));
        await tester.pump();

        expect(selectedRecipe, isNotNull);
        expect(selectedRecipe!.id, '123');
        expect(selectedRecipe!.title, 'Receta seleccionada');
      },
    );

    testWidgets(
      'Debe mostrar RefreshIndicator cuando existe onRefresh',
      (tester) async {
        await tester.pumpWidget(
          createWidget(
            recipes: [
              createRecipe(id: '1', title: 'Receta'),
            ],
            onRecipeTap: (_) {},
            onRefresh: () async {},
          ),
        );

        expect(find.byType(RefreshIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'No debe mostrar RefreshIndicator cuando onRefresh es null',
      (tester) async {
        await tester.pumpWidget(
          createWidget(
            recipes: [
              createRecipe(id: '1', title: 'Receta'),
            ],
            onRecipeTap: (_) {},
          ),
        );

        expect(find.byType(RefreshIndicator), findsNothing);
        expect(find.byType(ListView), findsOneWidget);
      },
    );

    testWidgets(
      'Lista vacía no debe mostrar RecipeCard',
      (tester) async {
        await tester.pumpWidget(
          createWidget(
            recipes: [],
            onRecipeTap: (_) {},
          ),
        );

        expect(find.byType(RecipeCard), findsNothing);
      },
    );
  });
}