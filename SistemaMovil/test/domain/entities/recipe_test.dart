import 'package:flutter_test/flutter_test.dart';
import 'package:Nutricional/domain/entities/recipe.dart';

void main() {

  group('Recipe Entity Tests', () {

    test('Debe crear una receta correctamente', () {

      final recipe = Recipe(
        id: '1',
        title: 'Ensalada',
        description: 'Muy rica',
        imageUrl: '',
        ingredients: ['Tomate'],
        steps: ['Cortar'],
        userId: '1',
        createdAt: DateTime.now(),
      );

      expect(recipe.title, 'Ensalada');
      expect(recipe.servings, 1);
      expect(recipe.preparationTime, 0);
      expect(recipe.category, '');
    });
  });
}