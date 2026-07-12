import { BaseRepository } from '../../repository/BaseRepository';
import { Recipe } from '../../models/Recipe';

class RecipeService {
  constructor() {
    this.repository = new BaseRepository('recipes');
  }

  /**
   * Obtener todas las recetas
   */
  async getAllRecipes() {
    const data = await this.repository.findAll({
      orderByField: 'createdAt',
      orderDirection: 'desc'
    });
    return data.map(item => new Recipe(item));
  }

  /**
   * Obtener una receta por ID
   */
  async getRecipeById(id) {
    const data = await this.repository.findById(id);
    return data ? new Recipe(data) : null;
  }

  /**
   * Buscar recetas por título o categoría
   */
  async searchRecipes(searchTerm) {
    const allRecipes = await this.getAllRecipes();
    return allRecipes.filter(recipe =>
      recipe.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
      recipe.category.toLowerCase().includes(searchTerm.toLowerCase()) ||
      recipe.description.toLowerCase().includes(searchTerm.toLowerCase())
    );
  }

  /**
   * Obtener recetas por categoría
   */
  async getRecipesByCategory(category) {
    const data = await this.repository.findAll({
      filters: [['category', '==', category]],
      orderByField: 'title'
    });
    return data.map(item => new Recipe(item));
  }

  /**
   * Crear una nueva receta
   */
  async createRecipe(recipeData) {
    const recipe = new Recipe(recipeData);
    const id = await this.repository.create(recipe.toJSON());
    return id;
  }

  /**
   * Actualizar una receta
   */
  async updateRecipe(id, recipeData) {
    const recipe = new Recipe(recipeData);
    await this.repository.update(id, recipe.toJSON());
  }

  /**
   * Eliminar una receta
   */
  async deleteRecipe(id) {
    await this.repository.delete(id);
  }

  /**
   * Obtener estadísticas de recetas
   */
  async getRecipeStats() {
    const recipes = await this.getAllRecipes();
    const categories = {};
    let totalTime = 0;
    let totalIngredients = 0;

    recipes.forEach(recipe => {
      categories[recipe.category] = (categories[recipe.category] || 0) + 1;
      totalTime += recipe.preparationTime || 0;
      totalIngredients += recipe.ingredients?.length || 0;
    });

    return {
      total: recipes.length,
      categories,
      totalTime: totalTime,
      totalIngredients: totalIngredients,
      averageTime: recipes.length > 0 ? totalTime / recipes.length : 0,
      averageIngredients: recipes.length > 0 ? totalIngredients / recipes.length : 0,
      topCategories: Object.entries(categories)
        .sort((a, b) => b[1] - a[1])
        .slice(0, 5)
    };
  }
}

export const recipeService = new RecipeService();
export default recipeService;