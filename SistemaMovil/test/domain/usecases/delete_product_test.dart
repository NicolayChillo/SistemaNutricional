import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:Nutricional/domain/repositories/product_repository.dart';
import 'package:Nutricional/domain/usecases/delete_product.dart';

class MockProductRepository extends Mock
    implements ProductRepository {}

void main() {
  late MockProductRepository repository;
  late DeleteProduct usecase;

  setUp(() {
    repository = MockProductRepository();
    usecase = DeleteProduct(repository);
  });

  test('Debe eliminar un producto', () async {

    when(() => repository.deleteProduct('1'))
        .thenAnswer((_) async {});

    await usecase('1');

    verify(() => repository.deleteProduct('1'))
        .called(1);
  });

  test('Debe lanzar excepción', () {

    when(() => repository.deleteProduct('1'))
        .thenThrow(Exception());

    expect(
      () => usecase('1'),
      throwsException,
    );
  });
}