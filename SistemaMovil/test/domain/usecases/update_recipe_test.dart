/// ===========================================================
/// TIPO DE PRUEBA:
/// ✔ Unit Test
/// ✔ Mock Test
/// ===========================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:Nutricional/domain/entities/recipe.dart';
import 'package:Nutricional/domain/repositories/recipe_repository.dart';
import 'package:Nutricional/domain/usecases/update_recipe.dart';

class MockRecipeRepository extends Mock
    implements RecipeRepository {}

void main() {
  late MockRecipeRepository repository;
  late UpdateRecipeUseCase useCase;

  setUp(() {
    repository = MockRecipeRepository();
    useCase = UpdateRecipeUseCase(repository);
  });

  final recipe = Recipe(
    id: '1',
    title: 'Pizza',
    description: '',
    imageUrl: '',
    ingredients: [],
    steps: [],
    userId: '1',
    createdAt: DateTime.now(),
  );

  test(
      'Debe actualizar una receta',
      () async {

    // Arrange
    when(() =>
            repository.updateRecipe(recipe))
        .thenAnswer((_) async {});

    // Act
    await useCase(recipe);

    // Assert
    verify(() =>
            repository.updateRecipe(recipe))
        .called(1);
  });

  test(
      'Debe lanzar excepción si falla',
      () async {

    // Arrange
    when(() =>
            repository.updateRecipe(recipe))
        .thenThrow(Exception());

    // Act + Assert
    expect(
      () => useCase(recipe),
      throwsException,
    );
  });
}