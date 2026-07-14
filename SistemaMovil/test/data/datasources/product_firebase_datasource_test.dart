import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Rutas relativas a tu código fuente
import '../../../lib/domain/entities/product.dart';
import '../../../lib/domain/entities/nutritional_info.dart';
import '../../../lib/data/datasources/product_firebase_datasource.dart';

void main() {
  // Variables globales para nuestros tests
  late FakeFirebaseFirestore fakeFirestore;
  late ProductFirebaseDatasource datasource;

  // Producto base para usar como modelo en las inserciones
  final testProduct = Product(
    id: '', 
    barcode: '777888999',
    name: 'Yogurt Griego',
    brand: 'Kiosko',
    imageUrl: '',
    category: 'Lácteos',
    nutritionalInfo: NutritionalInfo(calories: 120, protein: 10, carbohydrates: 5, fat: 0, fiber: 0, sugar: 4, sodium: 30, servingSize: '100g'),
    userId: 'user123',
    createdAt: DateTime(2026, 5, 20),
  );

  // setUp se ejecuta ANTES de cada test individual.
  // Nos asegura que la base de datos comience vacía y sin basura del test anterior.
  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    datasource = ProductFirebaseDatasource(firestore: fakeFirestore);
  });

  group('ProductFirebaseDatasource', () {
    
    // CASO 1: Creación de registros
    test('createProduct: Debe insertar el documento en Firestore y retornar el producto con un ID generado', () async {
      // ACT (Ejecutamos la función)
      final result = await datasource.createProduct(testProduct);

      // ASSERT (Comprobamos la respuesta de la función)
      expect(result.id, isNotEmpty, reason: 'Firebase debió asignarle un ID alfanumérico aleatorio');
      expect(result.name, 'Yogurt Griego');

      // ASSERT PROFUNDO (Vamos a la base de datos falsa a comprobar que sí se guardó físicamente)
      final snapshot = await fakeFirestore.collection('products').doc(result.id).get();
      expect(snapshot.exists, isTrue, reason: 'El documento debe existir en la colección "products"');
      expect(snapshot.data()?['barcode'], '777888999');
    });

    // CASO 2: Consultas con filtros y ordenamiento
    test('getProductsByUser: Debe retornar una lista ordenada del más reciente al más antiguo filtrada por usuario', () async {
      // ARRANGE (Preparamos el escenario inyectando 3 documentos crudos en Firestore)
      
      // 1. Producto viejo de nuestro usuario
      await fakeFirestore.collection('products').add({
        'name': 'Producto Viejo',
        'userId': 'user123', // Nuestro usuario
        'createdAt': Timestamp.fromDate(DateTime(2025, 1, 1)),
        'nutritionalInfo': {}
      });
      
      // 2. Producto nuevo de nuestro usuario
      await fakeFirestore.collection('products').add({
        'name': 'Producto Nuevo',
        'userId': 'user123', // Nuestro usuario
        'createdAt': Timestamp.fromDate(DateTime(2026, 6, 1)), // Fecha más reciente
        'nutritionalInfo': {}
      });
      
      // 3. Producto de un usuario intruso
      await fakeFirestore.collection('products').add({
        'name': 'Producto Intruso',
        'userId': 'hacker999', // Otro usuario
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'nutritionalInfo': {}
      });

      // ACT (Pedimos los productos de 'user123')
      final results = await datasource.getProductsByUser('user123');

      // ASSERT
      expect(results.length, 2, reason: 'Solo debió traer 2 productos, ignorando al hacker999');
      expect(results.first.name, 'Producto Nuevo', reason: 'El orden debe ser descendente (primero el de 2026, luego el de 2025)');
    });

    // CASO 3: Actualización y Eliminación
    test('deleteProduct: Debe remover permanentemente el documento de la colección', () async {
      // ARRANGE (Creamos un documento y guardamos su ID)
      final docRef = await fakeFirestore.collection('products').add({
        'name': 'Producto a eliminar',
        'userId': 'user123'
      });
      final idToDelete = docRef.id;

      // ACT (Llamamos a nuestro datasource para que lo elimine)
      await datasource.deleteProduct(idToDelete);

      // ASSERT (Vamos a buscarlo a la base de datos para confirmar su muerte)
      final snapshot = await fakeFirestore.collection('products').doc(idToDelete).get();
      expect(snapshot.exists, isFalse, reason: 'El documento debió ser borrado y ya no existir en Firestore');
    });

  });
}