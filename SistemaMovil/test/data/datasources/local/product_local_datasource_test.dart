import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Rutas relativas a tu código fuente
import '../../../../lib/domain/entities/product.dart';
import '../../../../lib/domain/entities/nutritional_info.dart';
import '../../../../lib/data/datasources/local/product_local_datasource.dart';
import '../../../../lib/data/datasources/local/database_helper.dart';

// =====================================================================
// 1. ZONA DE "MOCKS" Y CONFIGURACIÓN
// Explicación: Creamos un "Fake" de tu DatabaseHelper. En lugar de darle
// la base de datos real del celular, le inyectamos nuestra base de datos falsa
// que vivirá únicamente en la memoria RAM de tu computadora.
// =====================================================================
class FakeDatabaseHelper extends Fake implements DatabaseHelper {
  final Database db;
  FakeDatabaseHelper(this.db);

  @override
  Future<Database> get database async => db;
}

void main() {
  late Database db;
  late FakeDatabaseHelper fakeDbHelper;
  late ProductLocalDatasource datasource;

  // setUpAll se ejecuta UNA SOLA VEZ al inicio de todo.
  // Inicializa el motor de SQLite para que funcione nativamente en Windows.
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  // setUp se ejecuta ANTES DE CADA test.
  // Crea una base de datos nueva, vacía y en la memoria RAM.
  setUp(() async {
    db = await databaseFactory.openDatabase(
      inMemoryDatabasePath, // ¡La magia está aquí! No se guarda en el disco duro.
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          // Recreamos la estructura relacional exacta que espera tu código
          await db.execute('''
            CREATE TABLE products (
              id TEXT PRIMARY KEY,
              barcode TEXT,
              name TEXT,
              brand TEXT,
              imageUrl TEXT,
              category TEXT,
              nutritionalInfo TEXT,
              userId TEXT,
              createdAt TEXT,
              synced INTEGER,
              updatedAt TEXT,
              deleted INTEGER
            )
          ''');
        },
      ),
    );
    fakeDbHelper = FakeDatabaseHelper(db);
    datasource = ProductLocalDatasource(fakeDbHelper);
  });

  // tearDown se ejecuta DESPUÉS DE CADA test para cerrar y destruir la base de datos
  tearDown(() async {
    await db.close();
  });

  // Producto de prueba genérico
  final testProduct = Product(
    id: 'local_id_123', 
    barcode: '111222333',
    name: 'Avena Integral',
    brand: 'Quaker',
    imageUrl: '',
    category: 'Cereales',
    nutritionalInfo: NutritionalInfo(calories: 300, protein: 12, carbohydrates: 50, fat: 5, fiber: 10, sugar: 1, sodium: 5, servingSize: '100g'),
    userId: 'user123',
    createdAt: DateTime(2026, 6, 1),
  );

  // =====================================================================
  // 2. ZONA DE PRUEBAS (Demostración de persistencia y lógica de negocio)
  // =====================================================================
  group('ProductLocalDatasource', () {
    
    // CASO 1: Inserción y Lectura
    test('saveProduct y getProductById: Debe insertar en SQLite y recuperar los datos correctamente', () async {
      // ACT: Guardamos el producto (por defecto synced es false)
      await datasource.saveProduct(testProduct);

      // ACT: Lo buscamos en la base de datos
      final result = await datasource.getProductById('local_id_123');

      // ASSERT: Comprobamos que no sea nulo y que los datos coincidan
      expect(result, isNotNull, reason: 'El producto debió guardarse en SQLite');
      expect(result?.name, 'Avena Integral');
      expect(result?.barcode, '111222333');
      // Verificamos que el JSON de la información nutricional se decodificó bien
      expect(result?.nutritionalInfo.protein, 12);
    });

    // CASO 2: Lógica de Sincronización (Offline-First)
    test('getUnsyncedProducts: Debe retornar solo los productos que no han subido a la nube', () async {
      // ARRANGE: Guardamos un producto que NO está sincronizado
      await datasource.saveProduct(testProduct, synced: false);
      
      // ARRANGE: Guardamos un segundo producto que SÍ está sincronizado
      final syncedProduct = Product(
        id: 'local_id_456', barcode: '999', name: 'Leche', brand: 'Vita', imageUrl: '', category: 'Lácteos', 
        nutritionalInfo: NutritionalInfo(calories: 1, protein: 1, carbohydrates: 1, fat: 1, fiber: 1, sugar: 1, sodium: 1, servingSize: ''), 
        userId: 'user123', createdAt: DateTime.now()
      );
      await datasource.saveProduct(syncedProduct, synced: true);

      // ACT: Pedimos la lista de pendientes por sincronizar
      final unsyncedList = await datasource.getUnsyncedProducts();

      // ASSERT: Solo debe traernos el primero
      expect(unsyncedList.length, 1);
      expect(unsyncedList.first.name, 'Avena Integral');
    });

    // CASO 3: Eliminación Suave (Soft Delete)
    // Demuestra que entiendes que los datos no se borran físicamente de inmediato para no romper la sincronización
    test('deleteProduct: Debe marcar como eliminado (deleted=1) y ocultarlo de las consultas principales', () async {
      // ARRANGE: Guardamos el producto
      await datasource.saveProduct(testProduct);

      // ACT: Ejecutamos el borrado suave
      await datasource.deleteProduct('local_id_123');

      // ASSERT 1: Si lo buscamos por ID normal, ya no debe aparecer (porque la query filtra deleted = 0)
      final result = await datasource.getProductById('local_id_123');
      expect(result, isNull, reason: 'El producto no debe ser visible después del borrado suave');

      // ASSERT 2: Comprobamos que su ID aparece en la lista de "elementos borrados" listos para limpiar en la nube
      final deletedIds = await datasource.getDeletedProductIds();
      expect(deletedIds.contains('local_id_123'), isTrue);
    });

  });
}