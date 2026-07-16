import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

// Rutas relativas a tu código fuente
import '../../../lib/domain/entities/user.dart';
import '../../../lib/data/datasources/auth_api_datasource.dart';

void main() {
  group('AuthApiDatasource - loginWithApi', () {
    
    // CASO 1: Éxito total
    test('Debe retornar un User cuando la API responde HTTP 200 y status 100', () async {
      // ARRANGE: Simulamos un servidor backend comportándose perfectamente
      final mockClient = MockClient((request) async {
        final jsonResponse = {
          "status": 100,
          "data": "Bienvenido"
        };
        return http.Response(jsonEncode(jsonResponse), 200);
      });

      final datasource = AuthApiDatasource(client: mockClient);

      // ACT
      final result = await datasource.loginWithApi('estudiante@espe.edu.ec', '12345');

      // ASSERT: Validamos que haya troceado bien el correo para sacar el nombre
      expect(result, isA<User>());
      expect(result.email, 'estudiante@espe.edu.ec');
      expect(result.username, 'estudiante', reason: 'El username debe ser la primera parte del correo');
    });

    // CASO 2: Error de credenciales controladas por el backend
    test('Debe lanzar Excepción cuando la API responde HTTP 200 pero status es 400', () async {
      // ARRANGE
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({"status": 400}), 200);
      });
      final datasource = AuthApiDatasource(client: mockClient);

      // ACT & ASSERT: Verificamos que lance el error exacto
      expect(
        () async => await datasource.loginWithApi('test@test.com', 'clave_mala'),
        throwsA(predicate((e) => e.toString().contains('Credenciales incorrectas')))
      );
    });

    // CASO 3: Errores HTTP tradicionales (401, 404, 500)
    test('Debe lanzar Excepciones mapeadas según el código de estado HTTP', () async {
      // ARRANGE (Simulamos un 404 - Not Found)
      final mockClient404 = MockClient((request) async => http.Response('Not Found', 404));
      final datasource404 = AuthApiDatasource(client: mockClient404);

      // ACT & ASSERT
      expect(
        () async => await datasource404.loginWithApi('test@test.com', '123'),
        throwsA(predicate((e) => e.toString().contains('Usuario no encontrado')))
      );

      // ARRANGE (Simulamos un 401 - Unauthorized)
      final mockClient401 = MockClient((request) async => http.Response('Unauthorized', 401));
      final datasource401 = AuthApiDatasource(client: mockClient401);

      // ACT & ASSERT
      expect(
        () async => await datasource401.loginWithApi('test@test.com', '123'),
        throwsA(predicate((e) => e.toString().contains('Credenciales inválidas')))
      );
    });

    // CASO 4: Fallas físicas de conexión a Internet
    test('Debe interceptar SocketException y devolver un mensaje amigable', () async {
      // ARRANGE: Simulamos que el dispositivo no tiene señal WiFi o Datos
      final mockClient = MockClient((request) async {
        throw const SocketException('Falla de red');
      });
      final datasource = AuthApiDatasource(client: mockClient);

      // ACT & ASSERT
      expect(
        () async => await datasource.loginWithApi('test@test.com', '123'),
        throwsA(predicate((e) => e.toString().contains('No se pudo conectar al servidor')))
      );
    });

    // CASO 5: Respuesta con formato extraño (Manejo defensivo)
    test('Debe manejar errores si el backend devuelve un HTML o formato no esperado', () async {
      // ARRANGE: El servidor se volvió loco y mandó una lista en vez de un mapa
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode(["error", "raro"]), 200);
      });
      final datasource = AuthApiDatasource(client: mockClient);

      // ACT & ASSERT
      expect(
        () async => await datasource.loginWithApi('test@test.com', '123'),
        throwsA(predicate((e) => e.toString().contains('Respuesta del servidor con formato inválido')))
      );
    });

  });
}