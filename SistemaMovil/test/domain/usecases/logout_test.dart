import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:Nutricional/domain/usecases/logout.dart';

import 'mocks/mock_auth_repository.dart';

void main() {
  late MockAuthRepository repository;
  late LogoutUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = LogoutUseCase(repository);
  });

  group('LogoutUseCase', () {

    // ============================================================
    // TIPO:
    // ✔ Unit Test
    // ✔ Mock Test
    // OBJETIVO:
    // Verificar cierre de sesión.
    // ============================================================
    test('Debe cerrar sesión', () async {

      when(() =>
          repository.logout())
          .thenAnswer((_) async {});

      await useCase();

      verify(() =>
          repository.logout())
          .called(1);
    });

    // ============================================================
    // TIPO:
    // ✔ Exception Test
    // ============================================================
    test('Debe lanzar excepción', () async {

      when(() =>
          repository.logout())
          .thenThrow(Exception());

      expect(
        () => useCase(),
        throwsException,
      );
    });
  });
}