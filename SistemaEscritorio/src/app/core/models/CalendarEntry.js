export class CalendarEntry {
  constructor(data = {}) {
    this.id = data.id || null;
    this.userId = data.userId || '';
    this.recipeId = data.recipeId || '';
    this.recipeTitle = data.recipeTitle || '';
    this.recipeImageUrl = data.recipeImageUrl || '';
    this.scheduledDate = data.scheduledDate || null;
    this.mealType = data.mealType || 'lunch';
    this.notificationSent = data.notificationSent || false;
    this.createdAt = data.createdAt || null;
    this.updatedAt = data.updatedAt || null;
  }

  get mealTypeLabel() {
    const types = {
      breakfast: 'Desayuno',
      lunch: 'Almuerzo',
      dinner: 'Cena',
      snack: 'Merienda'
    };
    return types[this.mealType] || this.mealType;
  }

  get isPast() {
    return this.scheduledDate && new Date(this.scheduledDate) < new Date();
  }

  get isToday() {
    if (!this.scheduledDate) return false;
    const today = new Date();
    const date = new Date(this.scheduledDate);
    return date.toDateString() === today.toDateString();
  }

  toJSON() {
    return {
      id: this.id,
      userId: this.userId,
      recipeId: this.recipeId,
      recipeTitle: this.recipeTitle,
      recipeImageUrl: this.recipeImageUrl,
      scheduledDate: this.scheduledDate,
      mealType: this.mealType,
      notificationSent: this.notificationSent,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt
    };
  }
}