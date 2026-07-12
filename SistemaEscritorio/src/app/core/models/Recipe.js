export class Recipe {
  constructor(data = {}) {
    this.id = data.id || null;
    this.title = data.title || '';
    this.description = data.description || '';
    this.imageUrl = data.imageUrl || '';
    this.category = data.category || '';
    this.preparationTime = data.preparationTime || 0;
    this.servings = data.servings || 1;
    this.ingredients = data.ingredients || [];
    this.steps = data.steps || [];
    this.userId = data.userId || 'admin';
    this.createdAt = data.createdAt || null;
    this.updatedAt = data.updatedAt || null;
  }

  get totalPreparationTime() {
    return this.preparationTime;
  }

  get ingredientsCount() {
    return this.ingredients?.length || 0;
  }

  get stepsCount() {
    return this.steps?.length || 0;
  }

  get difficulty() {
    if (this.stepsCount <= 3) return 'Fácil';
    if (this.stepsCount <= 6) return 'Media';
    return 'Difícil';
  }

  toJSON() {
    return {
      id: this.id,
      title: this.title,
      description: this.description,
      imageUrl: this.imageUrl,
      category: this.category,
      preparationTime: this.preparationTime,
      servings: this.servings,
      ingredients: this.ingredients,
      steps: this.steps,
      userId: this.userId,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt
    };
  }
}