import 'package:flutter_test/flutter_test.dart';

// Rutas relativas a tus archivos
import '../../../lib/domain/entities/calendar_entry.dart';
import '../../../lib/data/repositories/calendar_repository_impl.dart';
import '../../../lib/data/datasources/calendar_firebase_datasource.dart';
import '../../../lib/data/datasources/local/calendar_local_datasource.dart';
import '../../../lib/data/services/connectivity_service.dart';

// =====================================================================
// 1. ZONA DE "FAKES"
// =====================================================================

class FakeCalendarEntry extends Fake implements CalendarEntry {
  @override
  final String id;
  
  FakeCalendarEntry(this.id);
}

class FakeConnectivity extends Fake implements ConnectivityService {
  bool isOnline = true;
  @override
  bool get isConnected => isOnline;
}

class FakeRemoteDatasource extends Fake implements CalendarFirebaseDatasource {
  bool failCloud = false;
  bool deleteCalled = false;
  
  @override
  Future<CalendarEntry> createEntry(CalendarEntry entry) async {
    if (failCloud) throw Exception('Error en Nube');
    // TRUCO: Simulamos que Firebase siempre le asigna un ID diferente al documento
    return FakeCalendarEntry('id_definitivo_firebase_999'); 
  }
  
  @override
  Future<void> deleteEntry(String id) async {
    if (failCloud) throw Exception('Error en Nube');
    deleteCalled = true;
  }
}

class FakeLocalDatasource extends Fake implements CalendarLocalDatasource {
  String? lastSavedId;
  bool savedSynced = false;
  bool savedUnsynced = false;
  
  String? softDeletedId;
  String? hardDeletedId;
  
  bool queriedDateRange = false;

  @override
  Future<void> saveEntry(CalendarEntry entry, {bool synced = false}) async {
    lastSavedId = entry.id;
    if (synced) savedSynced = true;
    else savedUnsynced = true;
  }

  @override
  Future<void> deleteEntry(String id) async {
    softDeletedId = id; // Borrado lógico (ocultar)
  }
  
  @override
  Future<void> hardDeleteEntry(String id) async {
    hardDeletedId = id; // Borrado físico (destruir)
  }

  @override
  Future<List<CalendarEntry>> getEntriesByDateRange(String userId, DateTime start, DateTime end) async {
    queriedDateRange = true;
    return [];
  }
}

// =====================================================================
// 2. ZONA DE PRUEBAS
// =====================================================================

void main() {
  late CalendarRepositoryImpl repository;
  late FakeRemoteDatasource fakeRemote;
  late FakeLocalDatasource fakeLocal;
  late FakeConnectivity fakeConnectivity;

  final testEntry = FakeCalendarEntry('id_temporal_local_123');

  setUp(() {
    fakeRemote = FakeRemoteDatasource();
    fakeLocal = FakeLocalDatasource();
    fakeConnectivity = FakeConnectivity();
    repository = CalendarRepositoryImpl(fakeRemote, fakeLocal, fakeConnectivity);
  });

  group('CalendarRepositoryImpl - Lógica de Negocio Central', () {
    
    // CASO 1: Reasignación de IDs de Firebase
    test('createEntry: Si Firebase cambia el ID, debe hacer hard-delete del temporal y guardar el definitivo', () async {
      fakeConnectivity.isOnline = true;
      
      await repository.createEntry(testEntry);
      
      // ASSERT: Verificamos tu genial lógica de reemplazo de IDs
      expect(fakeLocal.savedUnsynced, isTrue, reason: 'Debió guardar el temporal primero');
      expect(fakeLocal.hardDeletedId, 'id_temporal_local_123', reason: 'Al detectar que Firebase le dio un nuevo ID, debió destruir el temporal');
      expect(fakeLocal.lastSavedId, 'id_definitivo_firebase_999', reason: 'El último guardado en local debió ser con el ID definitivo de Firebase');
      expect(fakeLocal.savedSynced, isTrue, reason: 'El registro final debió quedar marcado como sincronizado');
    });

    // CASO 2: Optimización de Consultas por Rango
    test('getEntriesByDateRange: Siempre debe consultar exclusivamente a la base local (caché)', () async {
      fakeConnectivity.isOnline = true; // Aunque haya internet...
      
      await repository.getEntriesByDateRange('user_1', DateTime.now(), DateTime.now());
      
      expect(fakeLocal.queriedDateRange, isTrue, reason: 'Debió buscar en SQLite');
      // No verificamos Remote porque si lo llamara, nuestra app sería lenta al navegar meses
    });

    // CASO 3: Eliminación Online Exitosa
    test('deleteEntry: Si hay conexión y la nube borra bien, debe hacer hard-delete en local', () async {
      fakeConnectivity.isOnline = true;
      
      await repository.deleteEntry('plan_lunes_123');
      
      expect(fakeRemote.deleteCalled, isTrue, reason: 'Primero intenta en la nube');
      expect(fakeLocal.hardDeletedId, 'plan_lunes_123', reason: 'Como Firebase borró bien, puede destruir el local');
      expect(fakeLocal.softDeletedId, isNull, reason: 'No necesitaba hacer soft delete');
    });

    // CASO 4: Eliminación Offline o Fallida (Tolerancia a fallos)
    test('deleteEntry: Si falla la nube, debe hacer soft-delete local para sincronizar después', () async {
      fakeConnectivity.isOnline = true;
      fakeRemote.failCloud = true; // Simulamos que el internet se cortó a la mitad
      
      await repository.deleteEntry('plan_martes_456');
      
      expect(fakeLocal.softDeletedId, 'plan_martes_456', reason: 'Solo debió ocultarlo (soft delete) para borrarlo de verdad cuando vuelva el WiFi');
      expect(fakeLocal.hardDeletedId, isNull, reason: 'No debió destruirlo, o se perdería el rastro de la eliminación');
    });

  });
}