import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/domain/entities/recipe.dart';
import '../../../lib/presentation/organisms/headers/recipe_detail_header.dart';
import '../../../lib/presentation/organisms/recipe/recipe_info_section.dart';
import '../../../lib/presentation/organisms/recipe/recipe_ingredients_section.dart';
import '../../../lib/presentation/organisms/recipe/recipe_steps_section.dart';

void main() {
  late Recipe testRecipe;

  setUp(() {
    testRecipe = Recipe(
      id: 'recipe-1',
      title: 'Ensalada saludable',
      description: 'Una receta sencilla y nutritiva',
      imageUrl: '',
      ingredients: [
        'Lechuga',
        'Tomate',
        'Aguacate',
      ],
      steps: [
        'Lavar los ingredientes',
        'Cortar los vegetales',
        'Mezclar y servir',
      ],
      userId: 'user-1',
      createdAt: DateTime(2026, 7, 14),
      preparationTime: 15,
      servings: 2,
      category: 'Saludable',
    );
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              RecipeDetailHeader(recipe: testRecipe),
              RecipeInfoSection(recipe: testRecipe),
              RecipeIngredientsSection(
                ingredients: testRecipe.ingredients,
              ),
              RecipeStepsSection(
                steps: testRecipe.steps,
              ),
            ],
          ),
        ),
      ),
    );
  }

  group('RecipeDetailScreen Presentation Tests', () {
    testWidgets(
      'Debe mostrar correctamente el título de la receta',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(
          find.text('Ensalada saludable'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe mostrar correctamente la descripción',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(
          find.text('Una receta sencilla y nutritiva'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe mostrar todos los ingredientes',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Ingredientes'), findsOneWidget);
        expect(find.text('Lechuga'), findsOneWidget);
        expect(find.text('Tomate'), findsOneWidget);
        expect(find.text('Aguacate'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar todos los pasos de preparación',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Preparación'), findsOneWidget);

        expect(
          find.text('Lavar los ingredientes'),
          findsOneWidget,
        );

        expect(
          find.text('Cortar los vegetales'),
          findsOneWidget,
        );

        expect(
          find.text('Mezclar y servir'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe mostrar el tiempo de preparación',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('15 min'), findsOneWidget);
        expect(find.byIcon(Icons.timer), findsOneWidget);
      },
    );

    testWidgets(
        'Debe mostrar las porciones',
        (WidgetTester tester) async {
            await tester.pumpWidget(createTestWidget());

            final expectedText =
                '${testRecipe.servings} porción${testRecipe.servings > 1 ? 'es' : ''}';

            expect(find.text(expectedText), findsOneWidget);
            expect(find.byIcon(Icons.people), findsOneWidget);
        },
    );

    testWidgets(
      'Debe mostrar la categoría',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Saludable'), findsOneWidget);
        expect(find.byIcon(Icons.category), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar imagen placeholder cuando no existe imagen',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byIcon(Icons.restaurant), findsOneWidget);
      },
    );
  });
}