/// ===========================================================
/// TIPO DE PRUEBA:
/// ✔ Unit Test
/// ✔ Mock Test
/// ===========================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:Nutricional/domain/repositories/recipe_repository.dart';
import 'package:Nutricional/domain/usecases/delete_recipe.dart';

class MockRecipeRepository extends Mock
    implements RecipeRepository {}

void main() {
  late MockRecipeRepository repository;
  late DeleteRecipeUseCase useCase;

  setUp(() {
    repository = MockRecipeRepository();
    useCase = DeleteRecipeUseCase(repository);
  });

  test(
      'Debe eliminar una receta',
      () async {

    // Arrange
    when(() =>
            repository.deleteRecipe('1'))
        .thenAnswer((_) async {});

    // Act
    await useCase('1');

    // Assert
    verify(() =>
            repository.deleteRecipe('1'))
        .called(1);
  });

  test(
      'Debe lanzar excepción al eliminar',
      () async {

    // Arrange
    when(() =>
            repository.deleteRecipe('1'))
        .thenThrow(Exception());

    // Act + Assert
    expect(
      () => useCase('1'),
      throwsException,
    );
  });
}