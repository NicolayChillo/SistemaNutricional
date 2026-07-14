import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_data.dart';
import '../helpers/test_mocks.dart';
import '../helpers/test_helpers.dart';
import 'package:Nutricional/domain/usecases/create_recipe.dart';
import 'package:Nutricional/domain/usecases/get_recipes.dart';
import 'package:Nutricional/domain/usecases/update_recipe.dart';
import 'package:Nutricional/domain/usecases/delete_recipe.dart';

import 'package:Nutricional/domain/entities/recipe.dart';


void main() {
  late MockRecipeRepository mockRecipeRepo;
  late CreateRecipeUseCase createRecipe;
  late GetRecipesUseCase getRecipes;
  late UpdateRecipeUseCase updateRecipe;
  late DeleteRecipeUseCase deleteRecipe;

  const testUserId = 'int_user_001';

  setUp(() {
    mockRecipeRepo = MockFactory.createMockRecipeRepository();
    createRecipe = CreateRecipeUseCase(mockRecipeRepo);
    getRecipes = GetRecipesUseCase(mockRecipeRepo);
    updateRecipe = UpdateRecipeUseCase(mockRecipeRepo);
    deleteRecipe = DeleteRecipeUseCase(mockRecipeRepo);
  });

  tearDown(() {
    resetMocks([mockRecipeRepo]);
  });

  test('CRUD completo de receta', () async {
    final newRecipe = IntegrationTestData.testRecipe;
    final recipeWithId = Recipe(
      id: 'new_rec_001',
      title: newRecipe.title,
      description: newRecipe.description,
      imageUrl: newRecipe.imageUrl,
      ingredients: newRecipe.ingredients,
      steps: newRecipe.steps,
      userId: testUserId,
      createdAt: DateTime.now(),
      preparationTime: newRecipe.preparationTime,
      servings: newRecipe.servings,
      category: newRecipe.category,
    );

    when(mockRecipeRepo.createRecipe(any))
        .thenAnswer((_) async => recipeWithId);

    final created = await createRecipe(recipeWithId);
    when(mockRecipeRepo.getRecipesByUser(testUserId))
        .thenAnswer((_) async => [created]);
    expect(created.id, isNotEmpty);
    expect(created.title, equals(newRecipe.title));
    verify(mockRecipeRepo.createRecipe(any)).called(1);

    final recipeList = await getRecipes.callByUser(testUserId);
    expect(recipeList, isNotEmpty);
    expect(recipeList.any((r) => r.id == created.id), true);
    verify(mockRecipeRepo.getRecipesByUser(testUserId)).called(1);

    final updatedRecipe = Recipe(
      id: created.id,
      title: 'Receta Actualizada',
      description: created.description,
      imageUrl: created.imageUrl,
      ingredients: created.ingredients,
      steps: created.steps,
      userId: testUserId,
      createdAt: created.createdAt,
      preparationTime: created.preparationTime,
      servings: created.servings,
      category: created.category,
    );

    when(mockRecipeRepo.updateRecipe(updatedRecipe))
        .thenAnswer((_) async {});
    await updateRecipe(updatedRecipe);
    when(mockRecipeRepo.getRecipesByUser(testUserId))
        .thenAnswer((_) async => [updatedRecipe]);
    verify(mockRecipeRepo.updateRecipe(updatedRecipe)).called(1);

    when(mockRecipeRepo.deleteRecipe(created.id))
        .thenAnswer((_) async {});
    when(mockRecipeRepo.getRecipesByUser(testUserId))
        .thenAnswer((_) async => []);
    await deleteRecipe(created.id);
    verify(mockRecipeRepo.deleteRecipe(created.id)).called(1);

    final afterDeletion = await getRecipes.callByUser(testUserId);
    expect(afterDeletion.any((r) => r.id == created.id), false);
  });

  test('Obtener recetas globales', () async {
    when(mockRecipeRepo.getAllRecipes())
        .thenAnswer((_) async => [IntegrationTestData.testRecipe, IntegrationTestData.testRecipe2]);

    final allRecipes = await getRecipes.callAll();
    expect(allRecipes.length, greaterThanOrEqualTo(2));
  });
}