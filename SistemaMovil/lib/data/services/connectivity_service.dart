import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService instance = ConnectivityService._init();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();

  bool _isConnected = false;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  ConnectivityService._init();

  Stream<bool> get connectionStream => _connectionStatusController.stream;
  bool get isConnected => _isConnected;

  Future<void> initialize() async {
    _isConnected = await checkConnection();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) async {
      final hasConnection = _hasInternetConnection(result);
      if (_isConnected != hasConnection) {
        _isConnected = hasConnection;
        _connectionStatusController.add(_isConnected);
      }
    });
  }

  Future<bool> checkConnection() async {
    try {
      final ConnectivityResult result = await _connectivity.checkConnectivity();
      return _hasInternetConnection(result);
    } catch (e) {
      return false;
    }
  }

  bool _hasInternetConnection(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      return false;
    }

    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet) {
      return true;
    }

    return false;
  }

  Future<void> waitForConnection({Duration timeout = const Duration(seconds: 30)}) async {
    if (_isConnected) return;

    final completer = Completer<void>();
    StreamSubscription? subscription;

    subscription = connectionStream.listen((connected) {
      if (connected && !completer.isCompleted) {
        completer.complete();
        subscription?.cancel();
      }
    });

    Future.delayed(timeout, () {
      if (!completer.isCompleted) {
        subscription?.cancel();
        completer.completeError(TimeoutException('No se pudo establecer conexión'));
      }
    });

    return completer.future;
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionStatusController.close();
  }
}