import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_mocks.dart';

void main() {
  test('Detectar estado de conexión (conectado)', () async {
    final mockService = MockFactory.createMockConnectivityService(connected: true);
    expect(mockService.isConnected, true);
    final result = await mockService.checkConnection();
    expect(result, true);
  });

  test('Detectar estado de conexión (desconectado)', () async {
    final mockService = MockFactory.createMockConnectivityService(connected: false);
    expect(mockService.isConnected, false);
    final result = await mockService.checkConnection();
    expect(result, false);
  });

  test('Stream de cambios de conectividad', () async {
    final mockService = MockFactory.createMockConnectivityService(connected: true);
    final stream = mockService.connectionStream;
    expect(stream, isNotNull);

    bool received = false;
    final subscription = stream.listen((connected) {
      received = true;
      expect(connected, true);
    });

    await Future.delayed(const Duration(milliseconds: 100));
    expect(received, true);
    await subscription.cancel();
  });
}