import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_with_email.dart';
import '../../domain/usecases/register_with_email.dart';
import '../../domain/usecases/login_with_google.dart';
import '../../domain/usecases/login_with_facebook.dart';
import '../../domain/usecases/login_with_api.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/delete_account.dart';
import '../../data/datasources/auth_firebase_datasource.dart';
import '../../data/datasources/local/database_helper.dart';
import '../../data/datasources/local/session_local_datasource.dart';
import '../../data/datasources/local/user_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/services/connectivity_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isCheckingSession = true;

  late final LoginWithEmailUseCase _loginWithEmail;
  late final RegisterWithEmailUseCase _registerWithEmail;
  late final LoginWithGoogleUseCase _loginWithGoogle;
  late final LoginWithFacebookUseCase _loginWithFacebook;
  late final LoginWithApiUseCase _loginWithApi;
  late final LogoutUseCase _logout;
  late final DeleteAccountUseCase _deleteAccount;
  late final AuthFirebaseDatasource _datasource;
  late final SessionLocalDatasource _sessionDatasource;
  late final UserLocalDatasource _userLocalDatasource;
  late final ConnectivityService _connectivityService;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isCheckingSession => _isCheckingSession;

  AuthProvider() {
    _datasource = AuthFirebaseDatasource();
    final repository = AuthRepositoryImpl(_datasource);
    
    // Inicializar datasources locales
    final dbHelper = DatabaseHelper.instance;
    _sessionDatasource = SessionLocalDatasource(dbHelper);
    _userLocalDatasource = UserLocalDatasource(dbHelper);
    _connectivityService = ConnectivityService.instance;
    
    _loginWithEmail = LoginWithEmailUseCase(repository);
    _registerWithEmail = RegisterWithEmailUseCase(repository);
    _loginWithGoogle = LoginWithGoogleUseCase(repository);
    _loginWithFacebook = LoginWithFacebookUseCase(repository);
    _loginWithApi = LoginWithApiUseCase(repository);
    _logout = LogoutUseCase(repository);
    _deleteAccount = DeleteAccountUseCase(repository);
    
    // Verificar sesión guardada
    _checkSavedSession();
  }

  /// Verifica si hay una sesión guardada localmente
  Future<void> _checkSavedSession() async {
    _isCheckingSession = true;
    notifyListeners();

    try {
      // Verificar si hay sesión local
      final hasSession = await _sessionDatasource.hasActiveSession();
      
      if (hasSession) {
        // Verificar si la sesión ha expirado
        final isExpired = await _sessionDatasource.isSessionExpired();
        
        if (isExpired) {
          await _sessionDatasource.closeSession();
          _isCheckingSession = false;
          notifyListeners();
          return;
        }

        // Obtener usuario de la sesión
        final savedUser = await _sessionDatasource.getActiveSession();
        
        if (savedUser != null) {
          _currentUser = savedUser;
          
          // Intentar validar con Firebase solo si hay conexión
          if (_connectivityService.isConnected) {
            try {
              final firebaseUser = _datasource.getCurrentUser();
              if (firebaseUser != null && firebaseUser.id == savedUser.id) {
                // Usuario válido en Firebase
                print('Sesión válida en Firebase');
              } else {
                // El usuario no existe en Firebase, limpiar sesión
                print('Usuario no encontrado en Firebase, limpiando sesión');
                await _sessionDatasource.closeSession();
                _currentUser = null;
              }
            } catch (e) {
              print('Error al validar sesión con Firebase: $e');
              // Si hay error, mantenemos la sesión local
            }
          } else {
            print('Sin conexión, usando sesión local');
          }
        }
      } else {
        // No hay sesión local, verificar Firebase solo si hay conexión
        if (_connectivityService.isConnected) {
          try {
            _currentUser = _datasource.getCurrentUser();
            if (_currentUser != null) {
              // Guardar sesión de Firebase en local
              await _sessionDatasource.saveActiveSession(_currentUser!);
              await _userLocalDatasource.saveUser(_currentUser!);
            }
          } catch (e) {
            print('Error al obtener usuario de Firebase: $e');
          }
        }
      }
    } catch (e) {
      print('Error al verificar sesión: $e');
      _errorMessage = 'Error al verificar sesión: $e';
    } finally {
      _isCheckingSession = false;
      notifyListeners();
    }

    // Escuchar cambios en el estado de autenticación de Firebase
    _datasource.authStateChanges().listen((user) async {
      if (user != null && user.id != _currentUser?.id) {
        _currentUser = user;
        await _sessionDatasource.saveActiveSession(user);
        await _userLocalDatasource.saveUser(user);
        notifyListeners();
      } else if (user == null && _currentUser != null) {
        // Firebase cerró sesión
        _currentUser = null;
        await _sessionDatasource.closeSession();
        notifyListeners();
      }
    });
  }

  // Método para obtener mensajes de error amigables
  String getFriendlyErrorMessage(String error) {
    // Lista de errores comunes y sus mensajes amigables
    if (error.contains('email-already-in-use') || 
        error.contains('ya está registrado')) {
      return 'Este correo electrónico ya está registrado. ¿Deseas iniciar sesión?';
    }
    
    if (error.contains('user-not-found') || 
        error.contains('No existe una cuenta')) {
      return 'No encontramos una cuenta con este correo. Verifica o regístrate.';
    }
    
    if (error.contains('wrong-password') || 
        error.contains('Contraseña incorrecta')) {
      return 'Contraseña incorrecta. Por favor, inténtalo de nuevo.';
    }
    
    if (error.contains('weak-password') || 
        error.contains('muy débil')) {
      return 'La contraseña es muy débil. Debe tener al menos 6 caracteres.';
    }
    
    if (error.contains('invalid-email') || 
        error.contains('formato del correo')) {
      return 'El formato del correo electrónico no es válido.';
    }
    
    if (error.contains('too-many-requests') || 
        error.contains('Demasiados intentos')) {
      return 'Demasiados intentos fallidos. Por favor, espera unos minutos.';
    }
    
    if (error.contains('account-exists-with-different-credential')) {
      return 'Esta cuenta ya existe con otro método de inicio de sesión.';
    }
    
    if (error.contains('user-disabled')) {
      return 'Esta cuenta ha sido deshabilitada. Contacta con soporte.';
    }

    if (error.contains('conexión') || 
        error.contains('internet') ||
        error.contains('servidor') ||
        error.contains('connection') ||
        error.contains('network')) {
      return 'No se puede conectar al servidor. Verifica tu conexión a internet.';
    }
    
    // Si no coincide con ningún patrón conocido, devolver el mensaje original
    return error;
  }

  Future<void> loginWithEmail(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _loginWithEmail(email, password);
      
      // Guardar sesión localmente
      if (_currentUser != null) {
        await _sessionDatasource.saveActiveSession(_currentUser!);
        await _userLocalDatasource.saveUser(_currentUser!);
      }
    } catch (e) {
      // Usamos el mensaje amigable
      _errorMessage = getFriendlyErrorMessage(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerWithEmail(String email, String password, String displayName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _registerWithEmail(email, password, displayName);
      
      // Guardar sesión localmente
      if (_currentUser != null) {
        await _sessionDatasource.saveActiveSession(_currentUser!);
        await _userLocalDatasource.saveUser(_currentUser!);
      }
    } catch (e) {
      _errorMessage = getFriendlyErrorMessage(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _loginWithGoogle();
      
      // Guardar sesión localmente
      if (_currentUser != null) {
        await _sessionDatasource.saveActiveSession(_currentUser!);
        await _userLocalDatasource.saveUser(_currentUser!);
      }
    } catch (e) {
      _errorMessage = getFriendlyErrorMessage(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithFacebook() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _loginWithFacebook();
      
      // Guardar sesión localmente
      if (_currentUser != null) {
        await _sessionDatasource.saveActiveSession(_currentUser!);
        await _userLocalDatasource.saveUser(_currentUser!);
      }
    } catch (e) {
      _errorMessage = getFriendlyErrorMessage(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithApi(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _loginWithApi(email, password);
      
      // Guardar sesión localmente
      if (_currentUser != null) {
        await _sessionDatasource.saveActiveSession(_currentUser!);
        await _userLocalDatasource.saveUser(_currentUser!);
      }
    } catch (e) {
      _errorMessage = getFriendlyErrorMessage(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _logout();
      
      // Limpiar sesión local
      await _sessionDatasource.closeSession();
      
      _currentUser = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAccount() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _deleteAccount();
      
      // Limpiar sesión local
      await _sessionDatasource.closeSession();
      
      _currentUser = null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login unificado: intenta primero con API externa, luego con Firebase
  /// AHORA CON MEJOR MANEJO DE ERRORES Y PRIORIDAD A FIREBASE
  Future<void> loginUnified(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Verificar conexión a internet primero
      final hasConnection = await _connectivityService.checkConnection();
      
      if (!hasConnection) {
        throw Exception('No hay conexión a internet. Verifica tu red.');
      }

      // PRIMERO intentar con Firebase (más confiable)
      try {
        print('Intentando login con Firebase...');
        _currentUser = await _loginWithEmail(email, password);
        
        if (_currentUser != null) {
          print('Login con Firebase exitoso');
          await _sessionDatasource.saveActiveSession(_currentUser!);
          await _userLocalDatasource.saveUser(_currentUser!);
          
          // Intentar sincronizar con API en segundo plano
          _syncWithApiInBackground(email, password);
          
          return;
        }
      } catch (firebaseError) {
        print('Error en login con Firebase: $firebaseError');
        
        // Si el error es de conexión, no intentar API
        final errorStr = firebaseError.toString().toLowerCase();
        if (errorStr.contains('connection') || 
            errorStr.contains('network') ||
            errorStr.contains('timeout') ||
            errorStr.contains('internet')) {
          throw Exception('Error de conexión. Verifica tu internet.');
        }
        
        // Si Firebase falla por credenciales, no intentar API
        if (errorStr.contains('user-not-found') || 
            errorStr.contains('wrong-password') ||
            errorStr.contains('invalid-email')) {
          throw firebaseError;
        }
        
        // Si es otro error, intentar con API
        print('Firebase falló, intentando con API...');
      }

      // 2. Si Firebase falla, intentar con API externa
      try {
        print('Intentando login con API...');
        _currentUser = await _loginWithApi(email, password);
        
        if (_currentUser != null) {
          print('Login con API exitoso');
          await _sessionDatasource.saveActiveSession(_currentUser!);
          await _userLocalDatasource.saveUser(_currentUser!);
        }
      } catch (apiError) {
        print('Error en login con API: $apiError');
        // Si ambos fallan, lanzar error general
        throw Exception('No se pudo iniciar sesión. Verifica tus credenciales.');
      }
      
    } catch (e) {
      final friendlyMsg = getFriendlyErrorMessage(e.toString());
      _errorMessage = friendlyMsg;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sincronización en segundo plano con API
  Future<void> _syncWithApiInBackground(String email, String password) async {
    try {
      // Intentar login con API en segundo plano (sin bloquear UI)
      final apiUser = await _loginWithApi(email, password);
      if (apiUser != null && _currentUser != null) {
        // Si el usuario de API tiene más información, actualizar
        if (apiUser.username != _currentUser!.username) {
          _currentUser = apiUser;
          await _sessionDatasource.saveActiveSession(_currentUser!);
          await _userLocalDatasource.saveUser(_currentUser!);
          notifyListeners();
        }
        print('Sincronización con API completada');
      }
    } catch (e) {
      // Silenciar errores de sincronización en segundo plano
      print('Sincronización con API falló: $e');
    }
  }

  /// Login solo con Firebase (sin intentar API)
  Future<void> loginWithFirebaseOnly(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _loginWithEmail(email, password);
      
      if (_currentUser != null) {
        await _sessionDatasource.saveActiveSession(_currentUser!);
        await _userLocalDatasource.saveUser(_currentUser!);
      }
    } catch (e) {
      _errorMessage = getFriendlyErrorMessage(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}