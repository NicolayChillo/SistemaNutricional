import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_data.dart';
import '../helpers/test_mocks.dart';
import '../helpers/test_helpers.dart';
import 'package:Nutricional/domain/usecases/login_with_email.dart';
import 'package:Nutricional/domain/usecases/register_with_email.dart';
import 'package:Nutricional/domain/usecases/logout.dart';
import 'package:Nutricional/domain/usecases/delete_account.dart';

void main() {
  late MockAuthRepository mockAuthRepo;
  late LoginWithEmailUseCase loginWithEmail;
  late RegisterWithEmailUseCase registerWithEmail;
  late LogoutUseCase logout;
  late DeleteAccountUseCase deleteAccount;

  setUp(() {
    mockAuthRepo = MockFactory.createMockAuthRepository();
    loginWithEmail = LoginWithEmailUseCase(mockAuthRepo);
    registerWithEmail = RegisterWithEmailUseCase(mockAuthRepo);
    logout = LogoutUseCase(mockAuthRepo);
    deleteAccount = DeleteAccountUseCase(mockAuthRepo);
  });

  tearDown(() {
    resetMocks([mockAuthRepo]);
  });

  test('Registro -> Login -> Logout -> Delete Account', () async {
    final email = IntegrationTestData.testEmail;
    final password = IntegrationTestData.testPassword;
    final username = IntegrationTestData.testUsername;

    final registeredUser = await registerWithEmail(email, password, username);
    expect(registeredUser, isNotNull);
    expect(registeredUser.email, equals(email));
    verify(mockAuthRepo.registerWithEmail(email, password, username)).called(1);

    final loggedUser = await loginWithEmail(email, password);
    expect(loggedUser, isNotNull);
    expect(loggedUser.id, equals(registeredUser.id));
    verify(mockAuthRepo.loginWithEmail(email, password)).called(1);

    await logout();
    verify(mockAuthRepo.logout()).called(1);

    await deleteAccount();
    verify(mockAuthRepo.deleteAccount()).called(1);
  });

  test('Login fallido con credenciales incorrectas', () async {
    final email = 'wrong@test.com';
    final password = 'WrongPass123!';
    when(mockAuthRepo.loginWithEmail(email, password))
        .thenThrow(Exception('Credenciales incorrectas'));

    expect(() async => await loginWithEmail(email, password),
        throwsA(predicate((e) => e.toString().contains('Credenciales incorrectas'))));
  });

  test('Registro fallido con email existente', () async {
    final email = IntegrationTestData.testEmail;
    final password = IntegrationTestData.testPassword;
    final username = IntegrationTestData.testUsername;
    when(mockAuthRepo.registerWithEmail(email, password, username))
        .thenThrow(Exception('El email ya está registrado'));

    expect(() async => await registerWithEmail(email, password, username),
        throwsA(predicate((e) => e.toString().contains('ya está registrado'))));
  });
}