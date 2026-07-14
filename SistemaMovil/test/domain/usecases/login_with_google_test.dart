import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:Nutricional/domain/entities/user.dart';
import 'package:Nutricional/domain/usecases/login_with_google.dart';

import 'mocks/mock_auth_repository.dart';

void main() {
  late MockAuthRepository repository;
  late LoginWithGoogleUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginWithGoogleUseCase(repository);
  });

  group('LoginWithGoogleUseCase', () {

    // ============================================================
    // TIPO:
    // ✔ Unit Test
    // ✔ Mock Test
    // ============================================================
    test('Debe iniciar sesión con Google', () async {

      final user = User(
        id: '1',
        username: 'GoogleUser',
        email: 'google@test.com',
      );

      when(() =>
          repository.loginWithGoogle())
          .thenAnswer((_) async => user);

      final result = await useCase();

      expect(result.email,
          'google@test.com');

      verify(() =>
          repository.loginWithGoogle())
          .called(1);
    });

    // ============================================================
    // TIPO:
    // ✔ Exception Test
    // ============================================================
    test('Debe lanzar excepción', () async {

      when(() =>
          repository.loginWithGoogle())
          .thenThrow(Exception());

      expect(
        () => useCase(),
        throwsException,
      );
    });
  });
}