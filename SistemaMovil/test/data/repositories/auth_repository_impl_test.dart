import 'package:flutter_test/flutter_test.dart';

// Rutas relativas a tu código fuente
import '../../../lib/domain/entities/user.dart';
import '../../../lib/data/repositories/auth_repository_impl.dart';
import '../../../lib/data/datasources/auth_firebase_datasource.dart';
import '../../../lib/data/datasources/auth_api_datasource.dart';

// =====================================================================
// 1. ZONA DE "MOCKS" Y SIMULACROS
// Explicación: Creamos fuentes de datos falsas que no se conectan a internet.
// El objetivo de esta prueba es verificar que el "Cerebro" (Repositorio) 
// redirige las peticiones al lugar correcto.
// =====================================================================

// Truco PRO: Creamos un usuario falso para no lidiar con los campos obligatorios
// de la clase User original. Le ponemos una etiqueta para saber de dónde vino.
class FakeUser extends Fake implements User {
  final String sourceTag;
  FakeUser(this.sourceTag);
}

class FakeAuthFirebaseDatasource extends Fake implements AuthFirebaseDatasource {
  bool logoutCalled = false;
  bool deleteCalled = false;

  @override
  Future<User> loginWithEmail(String email, String password) async {
    return FakeUser('firebase_email');
  }

  @override
  Future<User> registerWithEmail(String email, String password, String displayName) async {
    return FakeUser('firebase_register');
  }

  @override
  Future<User> loginWithGoogle() async {
    return FakeUser('firebase_google');
  }

  @override
  Future<User> loginWithFacebook() async {
    return FakeUser('firebase_facebook');
  }

  @override
  Future<void> logout() async {
    logoutCalled = true; // Marcamos la bandera de que sí se llamó a cerrar sesión
  }

  @override
  Future<void> deleteAccount() async {
    deleteCalled = true; // Marcamos la bandera de eliminación
  }

  @override
  User? getCurrentUser() {
    return FakeUser('current_user');
  }

  @override
  Stream<User?> authStateChanges() {
    return Stream.value(FakeUser('stream_user'));
  }
}

class FakeAuthApiDatasource extends Fake implements AuthApiDatasource {
  @override
  Future<User> loginWithApi(String email, String password) async {
    return FakeUser('custom_api');
  }
}

// =====================================================================
// 2. ZONA DE PRUEBAS
// =====================================================================

void main() {
  late FakeAuthFirebaseDatasource firebaseDb;
  late FakeAuthApiDatasource apiDb;
  late AuthRepositoryImpl repository;

  // setUp limpia el escenario antes de cada test para que no se contaminen
  setUp(() {
    firebaseDb = FakeAuthFirebaseDatasource();
    apiDb = FakeAuthApiDatasource();
    // Aquí inyectamos nuestras bases falsas usando el constructor opcional
    repository = AuthRepositoryImpl(firebaseDb, apiDb);
  });

  group('AuthRepositoryImpl', () {
    
    // CASO 1: Inicio de sesión tradicional (Firebase)
    test('loginWithEmail: Debe redirigir la petición a FirebaseDatasource', () async {
      // ACT: Llamamos al repositorio
      final result = await repository.loginWithEmail('test@test.com', '123456');

      // ASSERT: Verificamos que el repositorio sacó la información del lugar correcto
      // Hacemos un 'cast' (as FakeUser) para poder leer nuestra etiqueta secreta
      expect((result as FakeUser).sourceTag, 'firebase_email');
    });

    // CASO 2: Redes Sociales
    test('loginWithGoogle y loginWithFacebook: Deben comunicarse con FirebaseDatasource', () async {
      final googleResult = await repository.loginWithGoogle();
      final facebookResult = await repository.loginWithFacebook();

      expect((googleResult as FakeUser).sourceTag, 'firebase_google');
      expect((facebookResult as FakeUser).sourceTag, 'firebase_facebook');
    });

    // CASO 3: API Propia (La bifurcación importante)
    // Este test demuestra que el repositorio sabe cuándo usar Firebase y cuándo usar tu propia API
    test('loginWithApi: Debe redirigir la petición a AuthApiDatasource', () async {
      final result = await repository.loginWithApi('test@test.com', '123456');

      expect((result as FakeUser).sourceTag, 'custom_api', 
          reason: 'Esta petición debió irse por el camino de la API, no por Firebase');
    });

    // CASO 4: Cierre y destrucción de sesión
    test('logout y deleteAccount: Deben ejecutar los comandos en FirebaseDatasource', () async {
      // ACT
      await repository.logout();
      await repository.deleteAccount();

      // ASSERT: Comprobamos nuestras "banderas" booleanas para saber si el código pasó por ahí
      expect(firebaseDb.logoutCalled, isTrue, reason: 'El repositorio debió pedirle a Firebase que cierre la sesión');
      expect(firebaseDb.deleteCalled, isTrue, reason: 'El repositorio debió pedirle a Firebase que borre la cuenta');
    });

    // CASO 5: Vigilancia de estado y sesión activa
    test('getCurrentUser y authStateChanges: Deben devolver el usuario activo', () async {
      final currentUser = repository.getCurrentUser();
      expect((currentUser as FakeUser).sourceTag, 'current_user');

      // Comprobamos los flujos de datos (Streams)
      final streamUser = await repository.authStateChanges().first;
      expect((streamUser as FakeUser).sourceTag, 'stream_user');
    });

  });
}