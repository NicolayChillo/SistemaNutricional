import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:Nutricional/domain/entities/user.dart';
import 'package:Nutricional/domain/usecases/login_with_facebook.dart';

import 'mocks/mock_auth_repository.dart';

void main() {
  late MockAuthRepository repository;
  late LoginWithFacebookUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginWithFacebookUseCase(repository);
  });

  group('LoginWithFacebookUseCase', () {

    // ============================================================
    // TIPO:
    // ✔ Unit Test
    // ✔ Mock Test
    // ============================================================
    test('Debe iniciar sesión con Facebook', () async {

      final user = User(
        id: '1',
        username: 'FacebookUser',
        email: 'facebook@test.com',
      );

      when(() =>
          repository.loginWithFacebook())
          .thenAnswer((_) async => user);

      final result = await useCase();

      expect(result.username,
          'FacebookUser');

      verify(() =>
          repository.loginWithFacebook())
          .called(1);
    });

    // ============================================================
    // TIPO:
    // ✔ Exception Test
    // ============================================================
    test('Debe lanzar excepción', () async {

      when(() =>
          repository.loginWithFacebook())
          .thenThrow(Exception());

      expect(
        () => useCase(),
        throwsException,
      );
    });
  });
}