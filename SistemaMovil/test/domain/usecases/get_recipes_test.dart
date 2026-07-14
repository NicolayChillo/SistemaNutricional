/// ===========================================================
/// TIPO DE PRUEBA:
/// ✔ Unit Test
/// ✔ Mock Test
/// ===========================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:Nutricional/domain/entities/recipe.dart';
import 'package:Nutricional/domain/repositories/recipe_repository.dart';
import 'package:Nutricional/domain/usecases/get_recipes.dart';

class MockRecipeRepository extends Mock
    implements RecipeRepository {}

void main() {
  late MockRecipeRepository repository;
  late GetRecipesUseCase useCase;

  setUp(() {
    repository = MockRecipeRepository();
    useCase = GetRecipesUseCase(repository);
  });

  final recipes = [
    Recipe(
      id: '1',
      title: 'Pizza',
      description: '',
      imageUrl: '',
      ingredients: [],
      steps: [],
      userId: 'user1',
      createdAt: DateTime.now(),
    )
  ];

  test(
      'Debe obtener recetas por usuario',
      () async {

    // Arrange
    when(() =>
            repository.getRecipesByUser('user1'))
        .thenAnswer((_) async => recipes);

    // Act
    final result =
        await useCase.callByUser('user1');

    // Assert
    expect(result.length, 1);

    verify(() =>
            repository.getRecipesByUser('user1'))
        .called(1);
  });

  test(
      'Debe retornar lista vacía',
      () async {

    // Arrange
    when(() =>
            repository.getRecipesByUser('user1'))
        .thenAnswer((_) async => []);

    // Act
    final result =
        await useCase.callByUser('user1');

    // Assert
    expect(result.isEmpty, true);
  });

  test(
      'Debe obtener todas las recetas',
      () async {

    // Arrange
    when(() =>
            repository.getAllRecipes())
        .thenAnswer((_) async => recipes);

    // Act
    final result =
        await useCase.callAll();

    // Assert
    expect(result.length, 1);

    verify(() =>
            repository.getAllRecipes())
        .called(1);
  });
}