// auth_firebase_datasource.dart - Versión mejorada

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../../domain/entities/user.dart' as entities;

class AuthFirebaseDatasource {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // Login con email y contraseña - CON MENSAJES DE ERROR ESPECÍFICOS
  Future<entities.User> loginWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('Usuario no encontrado');

      return entities.User(
        id: user.uid,
        username: user.displayName ?? user.email ?? 'Usuario',
        email: user.email ?? '',
      );
    } on auth.FirebaseAuthException catch (e) {
      // Mapeo de errores específicos de Firebase
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No existe una cuenta con este correo electrónico');
        case 'wrong-password':
          throw Exception('Contraseña incorrecta');
        case 'invalid-email':
          throw Exception('El formato del correo electrónico no es válido');
        case 'user-disabled':
          throw Exception('Esta cuenta ha sido deshabilitada');
        case 'too-many-requests':
          throw Exception('Demasiados intentos fallidos. Por favor, espera un momento');
        case 'operation-not-allowed':
          throw Exception('El inicio de sesión con email no está habilitado');
        default:
          throw Exception('Error al iniciar sesión: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error al iniciar sesión');
    }
  }

  // Registro con email y contraseña - CON MENSAJES DE ERROR ESPECÍFICOS
  Future<entities.User> registerWithEmail(String email, String password, String displayName) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('Error al crear usuario');

      // Actualizar el nombre de usuario
      await user.updateDisplayName(displayName);

      return entities.User(
        id: user.uid,
        username: displayName,
        email: user.email ?? '',
      );
    } on auth.FirebaseAuthException catch (e) {
      // Mapeo de errores específicos de Firebase para registro
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('Este correo electrónico ya está registrado');
        case 'invalid-email':
          throw Exception('El formato del correo electrónico no es válido');
        case 'operation-not-allowed':
          throw Exception('El registro con email no está habilitado');
        case 'weak-password':
          throw Exception('La contraseña es muy débil. Debe tener al menos 6 caracteres');
        case 'too-many-requests':
          throw Exception('Demasiados intentos. Por favor, espera un momento');
        default:
          throw Exception('Error al registrar usuario: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error al registrar usuario');
    }
  }

  // Login con Google - con manejo de errores mejorado
  Future<entities.User> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Inicio de sesión con Google cancelado');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken!,
        idToken: googleAuth.idToken!,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) throw Exception('Usuario no encontrado');

      return entities.User(
        id: user.uid,
        username: user.displayName ?? user.email ?? 'Usuario',
        email: user.email ?? '',
      );
    } on auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw Exception('Ya existe una cuenta con este correo usando otro método de inicio de sesión');
        case 'invalid-credential':
          throw Exception('Credencial de Google inválida');
        default:
          throw Exception('Error al iniciar sesión con Google: ${e.message}');
      }
    } catch (e) {
      if (e.toString().contains('cancelado')) {
        throw Exception('Inicio de sesión con Google cancelado');
      }
      throw Exception('Error al iniciar sesión con Google: $e');
    }
  }

  // Login con Facebook - con manejo de errores mejorado
  Future<entities.User> loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );

      if (result.status != LoginStatus.success) {
        if (result.status == LoginStatus.cancelled) {
          throw Exception('Inicio de sesión con Facebook cancelado');
        }
        throw Exception('Error al iniciar sesión con Facebook');
      }

      final auth.OAuthCredential facebookAuthCredential =
          auth.FacebookAuthProvider.credential(result.accessToken!.token);

      final userCredential = await _firebaseAuth.signInWithCredential(facebookAuthCredential);
      final user = userCredential.user;
      if (user == null) throw Exception('Usuario no encontrado');

      return entities.User(
        id: user.uid,
        username: user.displayName ?? user.email ?? 'Usuario',
        email: user.email ?? '',
      );
    } on auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw Exception('Ya existe una cuenta con este correo usando otro método de inicio de sesión');
        case 'invalid-credential':
          throw Exception('Credencial de Facebook inválida');
        default:
          throw Exception('Error al iniciar sesión con Facebook: ${e.message}');
      }
    } catch (e) {
      if (e.toString().contains('cancelado')) {
        throw Exception('Inicio de sesión con Facebook cancelado');
      }
      throw Exception('Error al iniciar sesión con Facebook: $e');
    }
  }

  // El resto de métodos permanecen igual...
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
  }

  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('No hay usuario autenticado');
    await user.delete();
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
  }

  entities.User? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return entities.User(
      id: user.uid,
      username: user.displayName ?? user.email ?? 'Usuario',
      email: user.email ?? '',
    );
  }

  Stream<entities.User?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return entities.User(
        id: user.uid,
        username: user.displayName ?? user.email ?? 'Usuario',
        email: user.email ?? '',
      );
    });
  }
}