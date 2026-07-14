import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Rutas relativas a tu código fuente
import '../../../lib/domain/entities/product.dart';
import '../../../lib/domain/entities/nutritional_info.dart';
import '../../../lib/data/repositories/product_repository_impl.dart';
import '../../../lib/data/datasources/local/product_local_datasource.dart';
import '../../../lib/data/datasources/product_firebase_datasource.dart';

// =====================================================================
// 1. ZONA DE "MOCKS" (SIMULACROS)
// Explicación: Para no afectar las bases de datos reales durante las pruebas,
// creamos clases "Fake" que interceptan las llamadas y nos dejan ver qué pasó.
// =====================================================================

class FakeLocalDatasource extends Fake implements ProductLocalDatasource {
  bool saveCalled = false;
  bool isSynced = false;
  
  @override
  // CORRECCIÓN APLICADA: Ahora coincide exactamente con el código de tus compañeros
  Future<void> saveProduct(Product product, {bool synced = false}) async {
    saveCalled = true; // Registramos que el repositorio sí mandó a guardar localmente
    isSynced = synced; // Registramos si lo mandó como sincronizado o no
  }
}

class FakeFirebaseDatasource extends Fake implements ProductFirebaseDatasource {
  bool createCalled = false;
  
  @override
  Future<Product> createProduct(Product product) async {
    createCalled = true; // Registramos que el repositorio intentó subir a la nube
    // Simulamos que Firebase nos devuelve el producto con un ID generado en la nube
    return Product(
      id: 'firebase_id_777', 
      barcode: product.barcode,
      name: product.name,
      brand: product.brand,
      imageUrl: product.imageUrl,
      category: product.category,
      nutritionalInfo: product.nutritionalInfo,
      userId: product.userId,
      createdAt: product.createdAt,
    );
  }
}

class FakeConnectivity extends Fake implements Connectivity {
  final ConnectivityResult result;
  
  // El constructor nos permite simular si el celular tiene internet o no
  FakeConnectivity(this.result);

  @override
  Future<ConnectivityResult> checkConnectivity() async {
    return result; 
  }
}

// =====================================================================
// 2. ZONA DE PRUEBAS
// =====================================================================

void main() {
  // Producto de prueba genérico que usaremos en todos los tests
  final testProduct = Product(
    id: '', 
    barcode: '12345', 
    name: 'Manzana', 
    brand: 'Fuji', 
    imageUrl: '', 
    category: 'Frutas', 
    nutritionalInfo: NutritionalInfo(calories: 50, protein: 0, carbohydrates: 10, fat: 0, fiber: 2, sugar: 8, sodium: 0, servingSize: '100g'), 
    userId: 'user123', 
    createdAt: DateTime.now()
  );

  group('ProductRepositoryImpl - createProduct', () {
    
    // CASO DE PRUEBA 1: Flujo ideal (Conexión a internet)
    // Explicación: Comprobamos que, si hay internet, el sistema guarde en local, 
    // luego suba a Firebase, y finalmente actualice el local con el ID de la nube.
    test('Cuando hay internet: Guarda en local, sube a Firebase y actualiza local', () async {
      // ARRANGE (Preparar: instanciamos nuestros simulacros con internet encendido)
      final localDb = FakeLocalDatasource();
      final firebaseDb = FakeFirebaseDatasource();
      final connectivity = FakeConnectivity(ConnectivityResult.wifi); // ¡Hay internet!
      
      final repository = ProductRepositoryImpl(localDb, firebaseDb, connectivity);

      // ACT (Actuar: mandamos a guardar el producto)
      final result = await repository.createProduct(testProduct);

      // ASSERT (Afirmar: Comprobamos qué hizo el código por detrás)
      expect(localDb.saveCalled, isTrue, reason: 'Debió guardar en la base local primero.');
      expect(firebaseDb.createCalled, isTrue, reason: 'Debió subir a Firebase porque había internet.');
      expect(localDb.isSynced, isTrue, reason: 'Debió marcarse como sincronizado (true) tras subir a Firebase.');
      expect(result.id, 'firebase_id_777', reason: 'El repositorio debió devolver el producto actualizado con el ID de Firebase.');
    });

    // CASO DE PRUEBA 2: Flujo offline (Sin internet)
    // Explicación: Comprobamos que, si el usuario está en la calle sin datos, 
    // la app no se cuelgue, sino que guarde localmente y posponga la subida a Firebase.
    test('Cuando NO hay internet: Guarda solo en local y retorna producto sin ID nube', () async {
      // ARRANGE (Preparar: internet apagado)
      final localDb = FakeLocalDatasource();
      final firebaseDb = FakeFirebaseDatasource();
      final connectivity = FakeConnectivity(ConnectivityResult.none); // ¡No hay internet!
      
      final repository = ProductRepositoryImpl(localDb, firebaseDb, connectivity);

      // ACT
      final result = await repository.createProduct(testProduct);

      // ASSERT
      expect(localDb.saveCalled, isTrue, reason: 'Debió guardar localmente para uso offline.');
      expect(firebaseDb.createCalled, isFalse, reason: 'NO debió intentar subir a Firebase sin internet.');
      expect(localDb.isSynced, isFalse, reason: 'Queda marcado como no sincronizado (false) para subirlo luego.');
      expect(result.id, '', reason: 'Como no subió, el ID sigue estando vacío.');
    });

  });
}