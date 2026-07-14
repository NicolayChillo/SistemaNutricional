import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/domain/entities/recipe.dart';
import '../../../../lib/presentation/atoms/smart_cached_image.dart';
import '../../../../lib/presentation/organisms/recipe/recipe_card.dart';

void main() {
  Recipe createRecipe({
    String imageUrl = '',
    int preparationTime = 30,
    int servings = 4,
    String category = 'Almuerzo',
  }) {
    return Recipe(
      id: 'recipe-1',
      title: 'Arroz con pollo',
      description: 'Una deliciosa receta fácil de preparar',
      imageUrl: imageUrl,
      ingredients: const ['Arroz', 'Pollo'],
      steps: const ['Cocinar', 'Servir'],
      userId: 'user-1',
      createdAt: DateTime(2026, 7, 14),
      preparationTime: preparationTime,
      servings: servings,
      category: category,
    );
  }

  Widget createWidget(
    Recipe recipe, {
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: RecipeCard(
          recipe: recipe,
          onTap: onTap ?? () {},
        ),
      ),
    );
  }

  group('RecipeCard Widget Tests', () {
    testWidgets('Debe mostrar título y descripción', (tester) async {
      await tester.pumpWidget(createWidget(createRecipe()));

      expect(find.text('Arroz con pollo'), findsOneWidget);
      expect(
        find.text('Una deliciosa receta fácil de preparar'),
        findsOneWidget,
      );
    });

    testWidgets(
      'Debe mostrar SmartCachedImage cuando existe URL',
      (tester) async {
        await tester.pumpWidget(
          createWidget(
            createRecipe(
              imageUrl: 'https://example.com/receta.jpg',
            ),
          ),
        );

        expect(find.byType(SmartCachedImage), findsOneWidget);

        final image = tester.widget<SmartCachedImage>(
          find.byType(SmartCachedImage),
        );

        expect(image.imageUrl, 'https://example.com/receta.jpg');
        expect(image.height, 140);
      },
    );

    testWidgets(
      'Debe mostrar icono restaurant cuando no existe imagen',
      (tester) async {
        await tester.pumpWidget(
          createWidget(createRecipe(imageUrl: '')),
        );

        expect(find.byType(SmartCachedImage), findsNothing);
        expect(find.byIcon(Icons.restaurant), findsOneWidget);
      },
    );

    testWidgets('Debe mostrar tiempo de preparación', (tester) async {
      await tester.pumpWidget(
        createWidget(createRecipe(preparationTime: 45)),
      );

      expect(find.text('45 min'), findsOneWidget);
      expect(find.byIcon(Icons.timer), findsOneWidget);
    });

    testWidgets('Debe mostrar número de porciones', (tester) async {
      await tester.pumpWidget(
        createWidget(createRecipe(servings: 4)),
      );

      expect(find.text('4 porciónes'), findsOneWidget);
      expect(find.byIcon(Icons.people), findsOneWidget);
    });

    testWidgets('Debe mostrar porción en singular', (tester) async {
      await tester.pumpWidget(
        createWidget(createRecipe(servings: 1)),
      );

      expect(find.text('1 porción'), findsOneWidget);
    });

    testWidgets('Debe mostrar categoría', (tester) async {
      await tester.pumpWidget(
        createWidget(createRecipe(category: 'Cena')),
      );

      expect(find.text('Cena'), findsOneWidget);
      expect(find.byType(Chip), findsOneWidget);
    });

    testWidgets(
      'No debe mostrar datos opcionales cuando están vacíos',
      (tester) async {
        await tester.pumpWidget(
          createWidget(
            createRecipe(
              preparationTime: 0,
              servings: 0,
              category: '',
            ),
          ),
        );

        expect(find.byIcon(Icons.timer), findsNothing);
        expect(find.byIcon(Icons.people), findsNothing);
        expect(find.byType(Chip), findsNothing);
      },
    );

    testWidgets('Debe ejecutar onTap', (tester) async {
  bool tapped = false;

  await tester.pumpWidget(
    createWidget(
      createRecipe(),
      onTap: () {
        tapped = true;
      },
    ),
  );

  // Buscar específicamente el InkWell que está dentro del RecipeCard
  final inkWellFinder = find.descendant(
    of: find.byType(RecipeCard),
    matching: find.byType(InkWell),
  ).first;

  await tester.tap(inkWellFinder);
  await tester.pump();

  expect(tapped, isTrue);
});
  });
}