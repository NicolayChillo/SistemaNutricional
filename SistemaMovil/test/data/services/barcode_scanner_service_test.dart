import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// Rutas a tu código (ajusta según necesites)
import '../../../lib/data/services/barcode_scanner_service.dart';

// =====================================================================
// 1. ZONA DE "FAKES"
// Explicación: Falsificamos la cámara y los datos que devuelve para 
// probar tu algoritmo sin necesidad de tener un celular físico.
// =====================================================================

// Creamos un controlador "Dummy" (Mudo). No hará nada, solo sirve 
// para engañar al servicio y que no intente prender la cámara de Windows/Mac.
class DummyScannerController extends Fake implements MobileScannerController {}

// Falsificamos un código de barras individual
class FakeBarcode extends Fake implements Barcode {
  @override
  final String? rawValue;
  
  FakeBarcode(this.rawValue);
}

// Falsificamos la captura (la imagen congelada que toma la cámara)
class FakeBarcodeCapture extends Fake implements BarcodeCapture {
  @override
  final List<Barcode> barcodes;

  FakeBarcodeCapture(this.barcodes);
}

// =====================================================================
// 2. ZONA DE PRUEBAS
// =====================================================================

void main() {
  late BarcodeScannerService service;

  setUp(() {
    // Inyectamos nuestro controlador mudo
    service = BarcodeScannerService(controller: DummyScannerController());
  });

  group('BarcodeScannerService - Lógica de Extracción', () {
    
    // CASO 1: Foto vacía
    test('extractBarcode: Debe retornar null si la captura no tiene códigos', () {
      // ARRANGE: La cámara tomó la foto pero no vio nada
      final emptyCapture = FakeBarcodeCapture([]);
      
      // ACT
      final result = service.extractBarcode(emptyCapture);
      
      // ASSERT
      expect(result, isNull, reason: 'No debería encontrar ningún código en una lista vacía');
    });

    // CASO 2: Códigos rotos o ilegibles
    test('extractBarcode: Debe ignorar códigos con valores nulos o vacíos', () {
      // ARRANGE: La cámara vio un reflejo de luz (nulo) y una sombra (vacío)
      final invalidCapture = FakeBarcodeCapture([
        FakeBarcode(null),
        FakeBarcode(''),
      ]);
      
      // ACT
      final result = service.extractBarcode(invalidCapture);
      
      // ASSERT
      expect(result, isNull, reason: 'Debe saltarse los códigos inválidos gracias a tus condicionales');
    });

    // CASO 3: Éxito total (El algoritmo perfecto)
    test('extractBarcode: Debe retornar el primer código de barras válido que encuentre', () {
      // ARRANGE: Simulamos un escenario complejo donde la cámara capturó 3 cosas a la vez
      final validCapture = FakeBarcodeCapture([
        FakeBarcode(null), // Un reflejo al inicio
        FakeBarcode('7861000000000'), // Código de barras real (Ecuador)
        FakeBarcode('123456'), // Otro código borroso atrás
      ]);
      
      // ACT
      final result = service.extractBarcode(validCapture);
      
      // ASSERT
      expect(result, '7861000000000', reason: 'Debe atrapar el primer código válido y detener el ciclo (return)');
    });

  });
}