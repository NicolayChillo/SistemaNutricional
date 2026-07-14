/// ===========================================================
/// ARCHIVO: create_recipe_test.dart
///
/// TIPO DE PRUEBA:
/// ✔ Unit Test
/// ✔ Mock Test
///
/// HERRAMIENTAS:
/// - flutter_test
/// - mocktail
///
/// PATRÓN:
/// Arrange -> Act -> Assert
/// ===========================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:Nutricional/domain/entities/recipe.dart';
import 'package:Nutricional/domain/repositories/recipe_repository.dart';
import 'package:Nutricional/domain/usecases/create_recipe.dart';

class MockRecipeRepository extends Mock
    implements RecipeRepository {}

void main() {
  late MockRecipeRepository repository;
  late CreateRecipeUseCase useCase;

  setUp(() {
    repository = MockRecipeRepository();
    useCase = CreateRecipeUseCase(repository);
  });

  final recipe = Recipe(
    id: '1',
    title: 'Pizza',
    description: 'Muy rica',
    imageUrl: '',
    ingredients: ['Queso'],
    steps: ['Hornear'],
    userId: 'user1',
    createdAt: DateTime.now(),
  );

  test(
      'Debe crear una receta correctamente',
      () async {

    // =========================
    // Arrange
    // Se configura el mock
    // =========================
    when(() => repository.createRecipe(recipe))
        .thenAnswer((_) async => recipe);

    // =========================
    // Act
    // Se ejecuta el caso de uso
    // =========================
    final result = await useCase(recipe);

    // =========================
    // Assert
    // Se verifica el resultado
    // =========================
    expect(result, recipe);

    verify(() =>
        repository.createRecipe(recipe))
        .called(1);
  });

  test(
      'Debe lanzar excepción si falla el repositorio',
      () async {

    // Arrange
    when(() => repository.createRecipe(recipe))
        .thenThrow(Exception());

    // Act + Assert
    expect(
      () => useCase(recipe),
      throwsException,
    );
  });
}