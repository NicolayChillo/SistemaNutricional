import 'package:Nutricional/domain/entities/user.dart';
import 'package:Nutricional/domain/entities/product.dart';
import 'package:Nutricional/domain/entities/recipe.dart';
import 'package:Nutricional/domain/entities/calendar_entry.dart';
import 'package:Nutricional/domain/entities/nutritional_info.dart';

class IntegrationTestData {
  // USUARIOS (quitar const)
  static final testUser = User(
    id: 'int_user_001',
    username: 'IntegrationUser',
    email: 'integration@test.com',
  );

  static final testUser2 = User(
    id: 'int_user_002',
    username: 'IntegrationUser2',
    email: 'integration2@test.com',
  );

  static final testEmail = 'integration@test.com';
  static final testPassword = 'Test123!';
  static final testUsername = 'IntegrationUser';

  // PRODUCTOS (quitar const en NutritionalInfo)
  static final testProduct = Product(
    id: 'int_prod_001',
    barcode: '1234567890123',
    name: 'Manzana Integración',
    brand: 'Marca Test',
    imageUrl: 'https://example.com/apple.jpg',
    category: 'Frutas',
    nutritionalInfo: NutritionalInfo(
      calories: 95,
      protein: 0.5,
      carbohydrates: 25.0,
      fat: 0.3,
      fiber: 4.4,
      sugar: 19.0,
      sodium: 0,
      servingSize: '100g',
    ),
    userId: 'int_user_001',
    createdAt: DateTime(2024, 1, 15),
  );

  static final testProduct2 = Product(
    id: 'int_prod_002',
    barcode: '9876543210987',
    name: 'Pan Integral Integración',
    brand: 'Marca Test 2',
    imageUrl: 'https://example.com/bread.jpg',
    category: 'Panadería',
    nutritionalInfo: NutritionalInfo(
      calories: 265,
      protein: 9.0,
      carbohydrates: 45.0,
      fat: 3.0,
      fiber: 7.0,
      sugar: 2.0,
      sodium: 150,
      servingSize: '100g',
    ),
    userId: 'int_user_001',
    createdAt: DateTime(2024, 1, 15),
  );

  static final testProduct3 = Product(
    id: 'int_prod_003',
    barcode: '5555555555555',
    name: 'Pechuga Pollo Integración',
    brand: 'Marca Test 3',
    imageUrl: 'https://example.com/chicken.jpg',
    category: 'Carnes',
    nutritionalInfo: NutritionalInfo(
      calories: 165,
      protein: 31.0,
      carbohydrates: 0,
      fat: 3.6,
      fiber: 0,
      sugar: 0,
      sodium: 70,
      servingSize: '100g',
    ),
    userId: 'int_user_001',
    createdAt: DateTime(2024, 1, 15),
  );

  // RECETAS
  static final testRecipe = Recipe(
    id: 'int_rec_001',
    title: 'Ensalada Integración',
    description: 'Ensalada completa para pruebas',
    imageUrl: 'https://example.com/salad.jpg',
    ingredients: ['Lechuga', 'Tomate', 'Pepino', 'Cebolla', 'Aceite Oliva'],
    steps: ['Lavar verduras', 'Cortar en trozos', 'Mezclar', 'Aliñar'],
    userId: 'int_user_001',
    createdAt: DateTime(2024, 1, 15),
    preparationTime: 15,
    servings: 2,
    category: 'Ensaladas',
  );

  static final testRecipe2 = Recipe(
    id: 'int_rec_002',
    title: 'Pasta Integración',
    description: 'Pasta con salsa para pruebas',
    imageUrl: 'https://example.com/pasta.jpg',
    ingredients: ['Pasta', 'Tomate', 'Ajo', 'Albahaca'],
    steps: ['Cocer pasta', 'Preparar salsa', 'Mezclar'],
    userId: 'int_user_001',
    createdAt: DateTime(2024, 1, 15),
    preparationTime: 30,
    servings: 4,
    category: 'Pastas',
  );

  // CALENDARIO
  static final testCalendarEntry = CalendarEntry(
    id: 'int_cal_001',
    userId: 'int_user_001',
    recipeId: 'int_rec_001',
    recipeTitle: 'Ensalada Integración',
    recipeImageUrl: 'https://example.com/salad.jpg',
    scheduledDate: DateTime(2024, 1, 15, 12, 0),
    mealType: 'lunch',
    notificationSent: false,
    createdAt: DateTime(2024, 1, 14),
  );

  static final testCalendarEntry2 = CalendarEntry(
    id: 'int_cal_002',
    userId: 'int_user_001',
    recipeId: 'int_rec_002',
    recipeTitle: 'Pasta Integración',
    recipeImageUrl: 'https://example.com/pasta.jpg',
    scheduledDate: DateTime(2024, 1, 16, 20, 0),
    mealType: 'dinner',
    notificationSent: false,
    createdAt: DateTime(2024, 1, 15),
  );

  // DATOS EN MASA
  static List<Product> generateBulkProducts(int count) {
    return List.generate(count, (index) {
      return Product(
        id: 'int_bulk_prod_$index',
        barcode: 'bulk${index.toString().padLeft(8, '0')}',
        name: 'Producto Bulk $index',
        brand: 'Bulk Brand',
        imageUrl: 'https://example.com/bulk_$index.jpg',
        category: 'Bulk',
        nutritionalInfo: NutritionalInfo(
          calories: 100,
          protein: 1.0,
          carbohydrates: 20.0,
          fat: 0.5,
          fiber: 2.0,
          sugar: 1.0,
          sodium: 0,
          servingSize: '100g',
        ),
        userId: 'int_user_001',
        createdAt: DateTime.now(),
      );
    });
  }

  static List<Recipe> generateBulkRecipes(int count) {
    return List.generate(count, (index) {
      return Recipe(
        id: 'int_bulk_rec_$index',
        title: 'Receta Bulk $index',
        description: 'Descripción de receta bulk $index',
        imageUrl: 'https://example.com/bulk_rec_$index.jpg',
        ingredients: ['Ing 1', 'Ing 2', 'Ing 3'],
        steps: ['Paso 1', 'Paso 2', 'Paso 3'],
        userId: 'int_user_001',
        createdAt: DateTime.now(),
        preparationTime: 10 + (index % 40),
        servings: 2 + (index % 6),
        category: 'Bulk',
      );
    });
  }

  static List<CalendarEntry> generateBulkCalendarEntries(int count, String userId) {
    final now = DateTime.now();
    return List.generate(count, (index) {
      return CalendarEntry(
        id: 'int_bulk_cal_$index',
        userId: userId,
        recipeId: 'rec_$index',
        recipeTitle: 'Receta Bulk $index',
        recipeImageUrl: 'https://example.com/rec_$index.jpg',
        scheduledDate: now.add(Duration(days: index % 30)),
        mealType: ['breakfast', 'lunch', 'dinner', 'snack'][index % 4],
        notificationSent: false,
        createdAt: now,
      );
    });
  }
}