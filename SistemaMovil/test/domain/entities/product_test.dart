import 'package:flutter_test/flutter_test.dart';
import 'package:Nutricional/domain/entities/product.dart';
import 'package:Nutricional/domain/entities/nutritional_info.dart';

void main() {
  group('Product Entity Tests', () {

    test('Debe crear un producto correctamente', () {

      // Arrange
      final nutrition = NutritionalInfo(
        calories: 100,
        protein: 5,
        carbohydrates: 20,
        fat: 2,
      );

      // Act
      final product = Product(
        id: '1',
        barcode: '123456',
        name: 'Manzana',
        brand: 'Fruit',
        imageUrl: 'url',
        category: 'Frutas',
        nutritionalInfo: nutrition,
        userId: 'user1',
        createdAt: DateTime.now(),
      );

      // Assert
      expect(product.name, 'Manzana');
      expect(product.barcode, '123456');
      expect(product.nutritionalInfo.calories, 100);
    });
  });
}