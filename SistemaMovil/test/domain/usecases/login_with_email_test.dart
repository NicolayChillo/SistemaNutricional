import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:Nutricional/domain/entities/user.dart';
import 'package:Nutricional/domain/usecases/login_with_email.dart';

import 'mocks/mock_auth_repository.dart';

void main() {
  late MockAuthRepository repository;
  late LoginWithEmailUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginWithEmailUseCase(repository);
  });

  group('LoginWithEmailUseCase', () {

    // ============================================================
    // TIPO DE PRUEBA:
    // ✔ Unit Test
    // ✔ Mock Test
    // OBJETIVO:
    // Verificar login exitoso.
    // ============================================================
    test('Debe iniciar sesión correctamente', () async {

      // Arrange
      final user = User(
        id: '1',
        username: 'Pablo',
        email: 'pablo@test.com',
      );

      when(() =>
          repository.loginWithEmail(
              'pablo@test.com',
              '123456'))
          .thenAnswer((_) async => user);

      // Act
      final result =
          await useCase(
              'pablo@test.com',
              '123456');

      // Assert
      expect(result.id, '1');

      verify(() =>
          repository.loginWithEmail(
              'pablo@test.com',
              '123456'))
          .called(1);
    });

    // ============================================================
    // TIPO:
    // ✔ Unit Test
    // ✔ Mock Exception Test
    // OBJETIVO:
    // Verificar manejo de errores.
    // ============================================================
    test('Debe lanzar excepción', () async {

      // Arrange
      when(() =>
          repository.loginWithEmail(
              any(),
              any()))
          .thenThrow(Exception());

      // Act + Assert
      expect(
        () => useCase(
            'correo',
            '123'),
        throwsException,
      );
    });
  });
}