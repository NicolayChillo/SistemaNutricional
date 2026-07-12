import recipeService from '../core/services/recipes/RecipeService';

export class RecipesController {
  constructor() {
    this.recipeService = recipeService;
  }

  async getAllRecipes() {
    try {
      return await this.recipeService.getAllRecipes();
    } catch (error) {
      console.error('RecipesController.getAllRecipes error:', error);
      throw error;
    }
  }

  async getRecipeById(id) {
    try {
      if (!id) throw new Error('ID de receta requerido');
      return await this.recipeService.getRecipeById(id);
    } catch (error) {
      console.error('RecipesController.getRecipeById error:', error);
      throw error;
    }
  }

  async createRecipe(recipeData) {
    try {
      if (!recipeData.title || !recipeData.ingredients?.length) {
        throw new Error('Título e ingredientes son requeridos');
      }
      return await this.recipeService.createRecipe(recipeData);
    } catch (error) {
      console.error('RecipesController.createRecipe error:', error);
      throw error;
    }
  }

  async updateRecipe(id, recipeData) {
    try {
      if (!id) throw new Error('ID de receta requerido');
      await this.recipeService.updateRecipe(id, recipeData);
    } catch (error) {
      console.error('RecipesController.updateRecipe error:', error);
      throw error;
    }
  }

  async deleteRecipe(id) {
    try {
      if (!id) throw new Error('ID de receta requerido');
      await this.recipeService.deleteRecipe(id);
    } catch (error) {
      console.error('RecipesController.deleteRecipe error:', error);
      throw error;
    }
  }
}

export const recipesController = new RecipesController();
export default recipesController;