import 'package:flutter_test/flutter_test.dart';
import 'package:Nutricional/domain/entities/user.dart';

void main() {

  group('User Entity Tests', () {
    // ======================================
    // TIPO DE PRUEBA:
    // Prueba Unitaria (Unit Test)
    // OBJETIVO:
    // Verificar que la entidad User
    // almacene correctamente sus datos.
    // ======================================

    test('Debe crear un usuario correctamente', () {

      final user = User(
        id: '1',
        username: 'Pablo',
        email: 'correo@test.com',
      );

      expect(user.id, '1');
      expect(user.username, 'Pablo');
      expect(user.email, 'correo@test.com');
    });
  });
}