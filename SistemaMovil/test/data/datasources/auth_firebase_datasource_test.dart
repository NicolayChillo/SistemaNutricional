import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// Rutas relativas
import '../../../lib/domain/entities/user.dart' as entities;
import '../../../lib/data/datasources/auth_firebase_datasource.dart';

// =====================================================================
// 1. ZONA DE "MOCKS" Y SIMULACROS NATIVOS
// Explicación: Creamos objetos falsos que se comportan exactamente como 
// las respuestas que darían Firebase, Google y Facebook al iniciar sesión.
// =====================================================================

// 1.1 Simulacro de Usuario de Firebase
class FakeAuthUser extends Fake implements auth.User {
  @override
  final String uid = 'id_firebase_999';
  @override
  final String? email = 'estudiante@espe.edu.ec';
  @override
  final String? displayName = 'Ary y Yo';

  @override
  Future<void> updateDisplayName(String? displayName) async {}
}

// 1.2 Simulacro de Credenciales
class FakeUserCredential extends Fake implements auth.UserCredential {
  @override
  final auth.User? user = FakeAuthUser();
}

// 1.3 Simulacro Principal de Firebase Auth
class FakeFirebaseAuth extends Fake implements auth.FirebaseAuth {
  bool isSignedOut = false;

  @override
  Future<auth.UserCredential> signInWithEmailAndPassword({required String email, required String password}) async {
    // Simulamos un error clásico si mandan la contraseña equivocada
    if (password == 'clave_mala') {
      throw auth.FirebaseAuthException(code: 'wrong-password');
    }
    return FakeUserCredential();
  }

  @override
  Future<void> signOut() async {
    isSignedOut = true;
  }
}

// 1.4 Simulacro de Google (CORREGIDO PARA VERSIÓN 6.3.0)
class FakeGoogleSignIn extends Fake implements GoogleSignIn {
  bool isSignedOut = false;
  
  @override
  // Ahora coincide exactamente con la firma del paquete original
  Future<GoogleSignInAccount?> signOut() async {
    isSignedOut = true;
    return null; 
  }
}

// 1.5 Simulacro de Facebook
class FakeFacebookAuth extends Fake implements FacebookAuth {
  bool isSignedOut = false;

  @override
  Future<void> logOut() async {
    isSignedOut = true;
  }
}

// =====================================================================
// 2. ZONA DE PRUEBAS
// =====================================================================

void main() {
  late FakeFirebaseAuth fakeFirebaseAuth;
  late FakeGoogleSignIn fakeGoogleSignIn;
  late FakeFacebookAuth fakeFacebookAuth;
  late AuthFirebaseDatasource datasource;

  setUp(() {
    fakeFirebaseAuth = FakeFirebaseAuth();
    fakeGoogleSignIn = FakeGoogleSignIn();
    fakeFacebookAuth = FakeFacebookAuth();
    
    // Inyectamos todas nuestras dependencias falsas
    datasource = AuthFirebaseDatasource(
      firebaseAuth: fakeFirebaseAuth,
      googleSignIn: fakeGoogleSignIn,
      facebookAuth: fakeFacebookAuth,
    );
  });

  group('AuthFirebaseDatasource', () {
    
    // CASO 1: Camino Feliz de Inicio de Sesión
    test('loginWithEmail: Debe mapear correctamente el User de Firebase a la Entidad de Dominio', () async {
      // ACT
      final result = await datasource.loginWithEmail('estudiante@espe.edu.ec', 'clave_correcta');

      // ASSERT: Comprobamos que sacó los datos del FakeAuthUser y los transformó
      expect(result, isA<entities.User>());
      expect(result.id, 'id_firebase_999');
      expect(result.email, 'estudiante@espe.edu.ec');
      expect(result.username, 'Ary y Yo', reason: 'Debe respetar el nombre de usuario configurado');
    });

    // CASO 2: Manejo de Excepciones Específicas
    // Explicación: Verificamos que el Switch de tu código intercepta los errores 
    // de Firebase y los convierte en mensajes en español para el usuario.
    test('loginWithEmail: Debe lanzar una Excepción en español si la contraseña es incorrecta', () async {
      // ACT & ASSERT: Usamos la función throwsA para atrapar el error antes de que rompa el test
      expect(
        () async => await datasource.loginWithEmail('correo@test.com', 'clave_mala'),
        throwsA(predicate((e) => e.toString().contains('Contraseña incorrecta')))
      );
    });

    // CASO 3: Destrucción de Sesiones Multisistema
    // Explicación: Cuando un usuario cierra sesión, por seguridad debemos asegurarnos 
    // de desconectarlo de Google, Facebook y Firebase simultáneamente.
    test('logout: Debe llamar al método signOut() de todas las plataformas sociales', () async {
      // ACT
      await datasource.logout();

      // ASSERT: Nuestras variables booleanas nos chismosean si la función pasó por ahí
      expect(fakeFirebaseAuth.isSignedOut, isTrue, reason: 'Debió cerrar sesión en Firebase');
      expect(fakeGoogleSignIn.isSignedOut, isTrue, reason: 'Debió revocar el token de Google');
      expect(fakeFacebookAuth.isSignedOut, isTrue, reason: 'Debió revocar el token de Facebook');
    });

  });
}