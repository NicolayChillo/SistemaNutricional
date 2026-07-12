export class Product {
  constructor(data = {}) {
    this.id = data.id || null;
    this.barcode = data.barcode || '';
    this.name = data.name || '';
    this.brand = data.brand || '';
    this.category = data.category || '';
    this.imageUrl = data.imageUrl || '';
    this.nutritionalInfo = data.nutritionalInfo || {
      calories: 0,
      protein: 0,
      carbohydrates: 0,
      fat: 0,
      fiber: 0,
      sugar: 0,
      sodium: 0,
      servingSize: '100g'
    };
    this.userId = data.userId || 'admin';
    this.createdAt = data.createdAt || null;
    this.updatedAt = data.updatedAt || null;
  }

  get caloriesPerServing() {
    return this.nutritionalInfo?.calories || 0;
  }

  get formattedNutritionalInfo() {
    const info = this.nutritionalInfo;
    return {
      'Calorías': `${info.calories} kcal`,
      'Proteínas': `${info.protein}g`,
      'Carbohidratos': `${info.carbohydrates}g`,
      'Grasas': `${info.fat}g`,
      'Fibra': `${info.fiber}g`,
      'Azúcar': `${info.sugar}g`,
      'Sodio': `${info.sodium}mg`,
      'Porción': info.servingSize
    };
  }

  toJSON() {
    return {
      id: this.id,
      barcode: this.barcode,
      name: this.name,
      brand: this.brand,
      category: this.category,
      imageUrl: this.imageUrl,
      nutritionalInfo: this.nutritionalInfo,
      userId: this.userId,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt
    };
  }
}