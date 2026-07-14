import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:Nutricional/domain/entities/product.dart';
import 'package:Nutricional/domain/entities/nutritional_info.dart';
import 'package:Nutricional/domain/repositories/product_repository.dart';
import 'package:Nutricional/domain/usecases/update_product.dart';

class MockProductRepository extends Mock
    implements ProductRepository {}

void main() {
  late MockProductRepository repository;
  late UpdateProduct usecase;
  late Product product;

  setUp(() {
    repository = MockProductRepository();
    usecase = UpdateProduct(repository);

    product = Product(
      id: '1',
      barcode: '123',
      name: 'Manzana',
      brand: '',
      imageUrl: '',
      category: '',
      nutritionalInfo: NutritionalInfo(
        calories: 100,
        protein: 1,
        carbohydrates: 20,
        fat: 0,
      ),
      userId: '1',
      createdAt: DateTime.now(),
    );
  });

  test('Debe actualizar un producto', () async {

    when(() => repository.updateProduct(product))
        .thenAnswer((_) async {});

    await usecase(product);

    verify(() => repository.updateProduct(product))
        .called(1);
  });

  test('Debe lanzar excepción', () {

    when(() => repository.updateProduct(product))
        .thenThrow(Exception());

    expect(
      () => usecase(product),
      throwsException,
    );
  });
}