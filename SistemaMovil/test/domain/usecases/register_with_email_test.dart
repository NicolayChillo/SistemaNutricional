import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:Nutricional/domain/entities/user.dart';
import 'package:Nutricional/domain/usecases/register_with_email.dart';

import 'mocks/mock_auth_repository.dart';

void main() {
  late MockAuthRepository repository;
  late RegisterWithEmailUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase =
        RegisterWithEmailUseCase(repository);
  });

  group('RegisterWithEmailUseCase', () {

    // ============================================================
    // TIPO:
    // ✔ Unit Test
    // ✔ Mock Test
    // OBJETIVO:
    // Registro correcto.
    // ============================================================
    test('Debe registrar usuario', () async {

      final user = User(
        id: '1',
        username: 'Pablo',
        email: 'pablo@test.com',
      );

      when(() =>
          repository.registerWithEmail(
              any(),
              any(),
              any()))
          .thenAnswer((_) async => user);

      final result =
          await useCase(
              'pablo@test.com',
              '123456',
              'Pablo');

      expect(result.username,
          'Pablo');

      verify(() =>
          repository.registerWithEmail(
              any(),
              any(),
              any()))
          .called(1);
    });

    // ============================================================
    // TIPO:
    // ✔ Exception Test
    // ============================================================
    test('Debe lanzar excepción', () async {

      when(() =>
          repository.registerWithEmail(
              any(),
              any(),
              any()))
          .thenThrow(Exception());

      expect(
        () => useCase(
            'correo',
            '123',
            'nombre'),
        throwsException,
      );
    });
  });
}