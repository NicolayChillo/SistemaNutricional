import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

// Rutas a tus archivos (ajusta los imports si es necesario)
import '../../../lib/domain/entities/recipe.dart';
import '../../../lib/data/datasources/local/recipe_local_datasource.dart';
import '../../../lib/data/datasources/recipe_firebase_datasource.dart';
import '../../../lib/data/services/connectivity_service.dart';
import '../../../lib/data/services/sync_service.dart';

// =====================================================================
// 1. ZONA DE "FAKES"
// Explicación: Simulamos el disco local, la nube y el internet para
// ver cómo reacciona nuestro coordinador general (SyncService).
// =====================================================================

class FakeRecipe extends Fake implements Recipe {
  @override
  final String id;
  @override
  final String title;
  
  FakeRecipe(this.id, {this.title = 'Receta Prueba'});
}

class FakeConnectivity extends Fake implements ConnectivityService {
  bool isOnline = true;
  // Simulamos el Stream de conectividad
  final _controller = StreamController<bool>.broadcast();

  @override
  bool get isConnected => isOnline;

  @override
  Stream<bool> get connectionStream => _controller.stream;

  void triggerConnectionChange(bool connected) {
    isOnline = connected;
    _controller.add(connected);
  }
}

class FakeLocal extends Fake implements RecipeLocalDatasource {
  List<Recipe> unsyncedRecipes = [];
  List<String> deletedIds = [];
  
  // "Banderas" para saber qué se ejecutó
  List<String> markedSyncedIds = [];
  List<String> hardDeletedIds = [];
  bool savedFromCloudCalled = false;

  @override
  Future<List<Recipe>> getUnsyncedRecipes() async => unsyncedRecipes;

  @override
  Future<List<String>> getDeletedUnsyncedRecipeIds() async => deletedIds;

  @override
  Future<void> markAsSynced(String id) async => markedSyncedIds.add(id);

  @override
  Future<void> hardDeleteRecipe(String id) async => hardDeletedIds.add(id);

  @override
  Future<void> saveRecipesFromCloud(List<Recipe> recipes) async {
    savedFromCloudCalled = true;
  }
}

class FakeRemote extends Fake implements RecipeFirebaseDatasource {
  List<String> existingCloudIds = [];
  
  // "Banderas"
  List<String> updatedIds = [];
  List<String> createdIds = [];
  List<String> deletedIds = [];

  @override
  Future<Recipe> getRecipeById(String id) async {
    if (existingCloudIds.contains(id)) return FakeRecipe(id);
    throw Exception('No encontrado (404)'); // Simulamos que Firebase no lo tiene
  }

  @override
  Future<Recipe> updateRecipe(Recipe recipe) async {
    updatedIds.add(recipe.id);
    return recipe;
  }

  @override
  Future<Recipe> createRecipe(Recipe recipe) async {
    createdIds.add(recipe.id);
    return recipe;
  }

  @override
  Future<void> deleteRecipe(String id) async {
    deletedIds.add(id);
  }

  @override
  Future<List<Recipe>> getRecipesByUser(String userId) async {
    return [FakeRecipe('receta_nube_1')];
  }
}

// =====================================================================
// 2. ZONA DE PRUEBAS
// =====================================================================

void main() {
  late FakeLocal local;
  late FakeRemote remote;
  late FakeConnectivity connectivity;
  late SyncService syncService;

  setUp(() {
    local = FakeLocal();
    remote = FakeRemote();
    connectivity = FakeConnectivity();
    syncService = SyncService(local, remote, connectivity);
  });

  group('SyncService - Lógica Central', () {
    
    // CASO 1: Creación vs Actualización (Upload)
    test('syncRecipes: Si un registro local no está en la nube, lo CREA; si está, lo ACTUALIZA', () async {
      // ARRANGE
      // Tenemos 2 recetas locales no sincronizadas
      local.unsyncedRecipes = [
        FakeRecipe('id_nueva_1'),
        FakeRecipe('id_vieja_2'),
      ];
      // Pero 'id_vieja_2' SÍ existe en la nube (quizás falló el check final la vez anterior)
      remote.existingCloudIds = ['id_vieja_2'];

      // ACT
      await syncService.syncRecipes();

      // ASSERT
      expect(remote.createdIds, contains('id_nueva_1'), reason: 'Debió crear la receta nueva');
      expect(remote.updatedIds, contains('id_vieja_2'), reason: 'Debió actualizar la receta que ya existía');
      
      // Ambas deben quedar marcadas como sincronizadas localmente
      expect(local.markedSyncedIds, contains('id_nueva_1'));
      expect(local.markedSyncedIds, contains('id_vieja_2'));
    });

    // CASO 2: Eliminación en la Nube
    test('syncRecipes: Debe purgar en la nube los registros marcados como eliminados localmente', () async {
      // ARRANGE
      local.deletedIds = ['id_a_borrar'];

      // ACT
      await syncService.syncRecipes();

      // ASSERT
      expect(remote.deletedIds, contains('id_a_borrar'), reason: 'Debió mandar la orden de borrado a Firebase');
      expect(local.hardDeletedIds, contains('id_a_borrar'), reason: 'Debió destruirla definitivamente del disco local');
    });

    // CASO 3: Cortafuegos de Conexión
    test('forceSyncNow: Si no hay conexión, debe lanzar Excepción antes de tocar datos', () async {
      // ARRANGE
      connectivity.isOnline = false;

      // ACT & ASSERT
      expect(
        () async => await syncService.forceSyncNow(),
        throwsA(isA<Exception>()),
        reason: 'Debe rechazar la orden de forzar sincronización sin internet'
      );
    });

    // CASO 4: Descarga de Datos (Download)
    test('downloadRecipesForUser: Debe traer datos de Firebase y pasarlos al Local Datasource', () async {
      // ACT
      await syncService.downloadRecipesForUser('user_1');

      // ASSERT
      expect(local.savedFromCloudCalled, isTrue, reason: 'Debió llamar a la función que guarda en caché');
    });

    // CASO 5: Protección de Concurrencia
    test('syncAll: Debe bloquear solicitudes duplicadas si ya está en progreso (_isSyncing = true)', () async {
      // ARRANGE
      // Le metemos una receta para que la subida tarde algo de tiempo
      local.unsyncedRecipes = [FakeRecipe('test')];
      
      // ACT
      // Lanzamos la sincronización sin el 'await' para que no pause la ejecución
      final future1 = syncService.syncAll();
      
      // Intentamos sincronizar OTRA VEZ inmediatamente (el estado debería ser isSyncing = true)
      final future2 = syncService.syncAll();

      // ASSERT
      expect(syncService.isSyncing, isTrue, reason: 'El candado de seguridad debería estar activado');
      
      // Esperamos a que terminen para no dejar procesos fantasmas
      await future1;
      await future2;
    });

  });
}