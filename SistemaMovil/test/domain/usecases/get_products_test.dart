import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:Nutricional/domain/entities/product.dart';
import 'package:Nutricional/domain/entities/nutritional_info.dart';
import 'package:Nutricional/domain/repositories/product_repository.dart';
import 'package:Nutricional/domain/usecases/get_products.dart';

class MockProductRepository extends Mock
    implements ProductRepository {}

void main() {
  late MockProductRepository repository;
  late GetProducts usecase;

  setUp(() {
    repository = MockProductRepository();
    usecase = GetProducts(repository);
  });

  test('Debe retornar lista de productos', () async {

    final products = [
      Product(
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
      )
    ];

    when(() => repository.getProductsByUser('1'))
        .thenAnswer((_) async => products);

    final result = await usecase('1');

    expect(result, products);

    verify(() => repository.getProductsByUser('1'))
        .called(1);
  });

  test('Debe retornar lista vacía', () async {

    when(() => repository.getProductsByUser('1'))
        .thenAnswer((_) async => []);

    final result = await usecase('1');

    expect(result.isEmpty, true);
  });

  test('Debe lanzar excepción', () {

    when(() => repository.getProductsByUser('1'))
        .thenThrow(Exception());

    expect(
      () => usecase('1'),
      throwsException,
    );
  });
}