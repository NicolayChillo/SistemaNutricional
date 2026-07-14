import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:Nutricional/domain/entities/product.dart';
import 'package:Nutricional/domain/entities/nutritional_info.dart';
import 'package:Nutricional/domain/repositories/product_repository.dart';
import 'package:Nutricional/domain/usecases/create_product.dart';

class MockProductRepository extends Mock
    implements ProductRepository {}

void main() {
  late MockProductRepository repository;
  late CreateProduct usecase;
  late Product product;

  setUp(() {
    repository = MockProductRepository();
    usecase = CreateProduct(repository);

    product = Product(
      id: '1',
      barcode: '123',
      name: 'Manzana',
      brand: 'Fruit',
      imageUrl: '',
      category: 'Fruta',
      nutritionalInfo: NutritionalInfo(
        calories: 100,
        protein: 1,
        carbohydrates: 20,
        fat: 0,
      ),
      userId: 'user1',
      createdAt: DateTime.now(),
    );
  });

  test('Debe crear un producto correctamente', () async {

    // Arrange
    when(() => repository.createProduct(product))
        .thenAnswer((_) async => product);

    // Act
    final result = await usecase(product);

    // Assert
    expect(result, product);

    verify(() => repository.createProduct(product))
        .called(1);
  });

  test('Debe lanzar excepción', () async {

    when(() => repository.createProduct(product))
        .thenThrow(Exception());

    expect(
      () => usecase(product),
      throwsException,
    );
  });
}