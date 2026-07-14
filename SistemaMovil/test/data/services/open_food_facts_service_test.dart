import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

// Utilizamos rutas relativas para evitar problemas con el nombre del paquete
import '../../../lib/domain/entities/product.dart';
import '../../../lib/data/services/open_food_facts_service.dart';

void main() {
  // group() nos sirve para organizar y agrupar todas las pruebas de este servicio
  group('OpenFoodFactsService - getProductByBarcode', () {
    
    // CASO DE PRUEBA 1: El camino feliz (Todo funciona bien y encuentra el producto)
    test('debe retornar un Product cuando la API responde 200 y status es 1', () async {
      // 1. ARRANGE (Preparar el escenario simulando la respuesta de la API)
      final mockClient = MockClient((request) async {
        final jsonResponse = {
          "status": 1,
          "product": {
            "product_name": "Galletas de Chocolate",
            "brands": "Marca Falsa",
            "serving_size": "30g",
            "nutriments": {
              "energy-kcal_100g": 450.0,
              "proteins_100g": 5.0
            }
          }
        };
        return http.Response(jsonEncode(jsonResponse), 200);
      });

      final service = OpenFoodFactsService(client: mockClient);

      // 2. ACT (Ejecutar la función que estamos evaluando)
      final result = await service.getProductByBarcode('123456789', 'user123');

      // 3. ASSERT (Comprobar que el resultado mapeó los datos correctamente)
      expect(result, isA<Product>());
      expect(result?.name, 'Galletas de Chocolate');
      expect(result?.barcode, '123456789');
      expect(result?.nutritionalInfo.calories, 450.0);
    });

    // CASO DE PRUEBA 2: El producto no existe en la base de datos
    test('debe retornar null cuando la API responde 200 pero el status es 0', () async {
      // 1. ARRANGE
      final mockClient = MockClient((request) async {
        final jsonResponse = {
          "status": 0,
          "status_verbose": "product not found"
        };
        return http.Response(jsonEncode(jsonResponse), 200);
      });

      final service = OpenFoodFactsService(client: mockClient);

      // 2. ACT
      final result = await service.getProductByBarcode('000000000', 'user123');

      // 3. ASSERT (Comprobar que la función maneja el error y retorna null)
      expect(result, isNull);
    });

    // CASO DE PRUEBA 3: Falla el servidor de la API
    test('debe retornar null cuando ocurre un error de servidor (código 500)', () async {
      // 1. ARRANGE
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final service = OpenFoodFactsService(client: mockClient);

      // 2. ACT
      final result = await service.getProductByBarcode('123456789', 'user123');

      // 3. ASSERT (Comprobar que el bloque try-catch atrapa el error y retorna null)
      expect(result, isNull);
    });

  });
}