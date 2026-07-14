import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_data.dart';
import '../helpers/test_mocks.dart';
import '../helpers/test_helpers.dart';
import 'package:Nutricional/domain/usecases/create_product.dart';
import 'package:Nutricional/domain/usecases/get_products.dart';
import 'package:Nutricional/domain/usecases/update_product.dart';
import 'package:Nutricional/domain/usecases/delete_product.dart';

import 'package:Nutricional/domain/entities/product.dart';

void main() {
  late MockProductRepository mockProductRepo;
  late CreateProduct createProduct;
  late GetProducts getProducts;
  late UpdateProduct updateProduct;
  late DeleteProduct deleteProduct;

  const testUserId = 'int_user_001';

  setUp(() {
    mockProductRepo = MockFactory.createMockProductRepository();
    createProduct = CreateProduct(mockProductRepo);
    getProducts = GetProducts(mockProductRepo);
    updateProduct = UpdateProduct(mockProductRepo);
    deleteProduct = DeleteProduct(mockProductRepo);
  });

  tearDown(() {
    resetMocks([mockProductRepo]);
  });

  test('CRUD completo de producto', () async {
    final newProduct = IntegrationTestData.testProduct;
    final productWithId = Product(
      id: 'new_prod_001',
      barcode: newProduct.barcode,
      name: newProduct.name,
      brand: newProduct.brand,
      imageUrl: newProduct.imageUrl,
      category: newProduct.category,
      nutritionalInfo: newProduct.nutritionalInfo,
      userId: testUserId,
      createdAt: DateTime.now(),
    );

    when(mockProductRepo.createProduct(any))
        .thenAnswer((_) async => productWithId);

    final created = await createProduct(productWithId);
    when(mockProductRepo.getProductsByUser(testUserId))
        .thenAnswer((_) async => [created]);
    expect(created.id, isNotEmpty);
    expect(created.barcode, equals(newProduct.barcode));
    verify(mockProductRepo.createProduct(any)).called(1);

    final productList = await getProducts(testUserId);
    expect(productList, isNotEmpty);
    expect(productList.any((p) => p.id == created.id), true);
    verify(mockProductRepo.getProductsByUser(testUserId)).called(1);

    final updatedProduct = Product(
      id: created.id,
      barcode: created.barcode,
      name: 'Producto Actualizado',
      brand: created.brand,
      imageUrl: created.imageUrl,
      category: created.category,
      nutritionalInfo: created.nutritionalInfo,
      userId: testUserId,
      createdAt: created.createdAt,
    );

    when(mockProductRepo.updateProduct(updatedProduct))
        .thenAnswer((_) async {});
    await updateProduct(updatedProduct);
    when(mockProductRepo.getProductsByUser(testUserId))
        .thenAnswer((_) async => [updatedProduct]);
    verify(mockProductRepo.updateProduct(updatedProduct)).called(1);

    when(mockProductRepo.deleteProduct(created.id))
        .thenAnswer((_) async {});
    when(mockProductRepo.getProductsByUser(testUserId))
        .thenAnswer((_) async => []);
    await deleteProduct(created.id);
    verify(mockProductRepo.deleteProduct(created.id)).called(1);

    final afterDeletion = await getProducts(testUserId);
    expect(afterDeletion.any((p) => p.id == created.id), false);
  });

  test('Buscar producto por código de barras', () async {
    final barcode = '1234567890123';
    when(mockProductRepo.getProductByBarcode(barcode))
        .thenAnswer((_) async => IntegrationTestData.testProduct);

    final found = await mockProductRepo.getProductByBarcode(barcode);
    expect(found, isNotNull);
    expect(found!.barcode, equals(barcode));
  });
}