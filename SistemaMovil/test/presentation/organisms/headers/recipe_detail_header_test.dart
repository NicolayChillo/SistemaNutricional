import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/domain/entities/recipe.dart';
import '../../../../lib/presentation/atoms/smart_cached_image.dart';
import '../../../../lib/presentation/organisms/headers/recipe_detail_header.dart';

void main() {
  Recipe createTestRecipe({
    String imageUrl = '',
  }) {
    return Recipe(
      id: 'recipe-1',
      title: 'Arroz con pollo',
      description: 'Una receta deliciosa',
      imageUrl: imageUrl,
      ingredients: const [
        'Arroz',
        'Pollo',
      ],
      steps: const [
        'Cocinar el arroz',
        'Agregar el pollo',
      ],
      userId: 'user-1',
      createdAt: DateTime(2026, 7, 14),
      preparationTime: 30,
      servings: 4,
      category: 'Almuerzo',
    );
  }

  group('RecipeDetailHeader Widget Tests', () {
    testWidgets(
      'Debe mostrar SmartCachedImage cuando existe imageUrl',
      (WidgetTester tester) async {
        final recipe = createTestRecipe(
          imageUrl: 'https://example.com/receta.jpg',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeDetailHeader(recipe: recipe),
            ),
          ),
        );

        expect(find.byType(RecipeDetailHeader), findsOneWidget);
        expect(find.byType(SmartCachedImage), findsOneWidget);
      },
    );

    testWidgets(
      'Debe pasar correctamente la URL al SmartCachedImage',
      (WidgetTester tester) async {
        final recipe = createTestRecipe(
          imageUrl: 'https://example.com/receta.jpg',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeDetailHeader(recipe: recipe),
            ),
          ),
        );

        final SmartCachedImage image = tester.widget<SmartCachedImage>(
          find.byType(SmartCachedImage),
        );

        expect(
          image.imageUrl,
          'https://example.com/receta.jpg',
        );
        expect(image.height, 250);
        expect(image.width, double.infinity);
        expect(image.fit, BoxFit.cover);
      },
    );

    testWidgets(
      'Debe mostrar icono restaurant cuando imageUrl está vacío',
      (WidgetTester tester) async {
        final recipe = createTestRecipe();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeDetailHeader(recipe: recipe),
            ),
          ),
        );

        expect(find.byType(SmartCachedImage), findsNothing);
        expect(find.byIcon(Icons.restaurant), findsOneWidget);
      },
    );

    testWidgets(
      'Debe proporcionar widget de error para imagen dañada',
      (WidgetTester tester) async {
        final recipe = createTestRecipe(
          imageUrl: 'https://example.com/imagen.jpg',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecipeDetailHeader(recipe: recipe),
            ),
          ),
        );

        final SmartCachedImage image = tester.widget<SmartCachedImage>(
          find.byType(SmartCachedImage),
        );

        expect(image.errorWidget, isNotNull);
      },
    );
  });
}