import 'package:flutter_test/flutter_test.dart';

// Rutas a tus archivos
import '../../../lib/domain/entities/recipe.dart';
import '../../../lib/data/repositories/recipe_repository_impl.dart';
import '../../../lib/data/datasources/recipe_firebase_datasource.dart';
import '../../../lib/data/datasources/local/recipe_local_datasource.dart';
import '../../../lib/data/services/connectivity_service.dart';

// =====================================================================
// 1. ZONA DE "FAKES" (Sin usar librerías externas que rompan el código)
// =====================================================================

// TRUCO PRO: Receta de mentira que engaña al sistema para no tener que 
// saber qué campos obligatorios reales tiene tu clase Recipe.
class FakeRecipe extends Fake implements Recipe {
  @override
  final String id;
  
  FakeRecipe(this.id);
}

class FakeConnectivity extends Fake implements ConnectivityService {
  bool isOnline = true; // Controlamos el internet desde aquí
  
  @override
  bool get isConnected => isOnline;
}

class FakeRemoteDatasource extends Fake implements RecipeFirebaseDatasource {
  bool failCloud = false; // Controlamos si la nube se cae
  bool deleteCalled = false;
  
  @override
  Future<Recipe> createRecipe(Recipe recipe) async {
    if (failCloud) throw Exception('Error Nube');
    return recipe; // Devolvemos la misma receta para simular éxito
  }
  
  @override
  Future<List<Recipe>> getRecipesByUser(String userId) async {
    if (failCloud) throw Exception('Error Nube');
    return [FakeRecipe('receta_nube_1')];
  }
  
  @override
  Future<void> deleteRecipe(String id) async {
    if (failCloud) throw Exception('Error Nube');
    deleteCalled = true;
  }
}

class FakeLocalDatasource extends Fake implements RecipeLocalDatasource {
  bool savedSynced = false;
  bool savedUnsynced = false;
  bool softDeleteCalled = false;
  bool hardDeleteCalled = false;

  @override
  Future<void> saveRecipe(Recipe recipe, {bool synced = false}) async {
    if (synced) {
      savedSynced = true;
    } else {
      savedUnsynced = true;
    }
  }

  @override
  Future<List<Recipe>> getRecipesByUser(String userId) async {
    return [FakeRecipe('receta_local_1')];
  }
  
  @override
  Future<void> deleteRecipe(String id) async {
    softDeleteCalled = true;
  }
  
  @override
  Future<void> hardDeleteRecipe(String id) async {
    hardDeleteCalled = true;
  }
}

// =====================================================================
// 2. ZONA DE PRUEBAS
// =====================================================================

void main() {
  late RecipeRepositoryImpl repository;
  late FakeRemoteDatasource fakeRemote;
  late FakeLocalDatasource fakeLocal;
  late FakeConnectivity fakeConnectivity;

  final testRecipe = FakeRecipe('123');

  setUp(() {
    fakeRemote = FakeRemoteDatasource();
    fakeLocal = FakeLocalDatasource();
    fakeConnectivity = FakeConnectivity();
    
    // Inyectamos nuestros clones
    repository = RecipeRepositoryImpl(fakeRemote, fakeLocal, fakeConnectivity);
  });

  group('RecipeRepositoryImpl - Estrategia Offline-First', () {
    
    // CASO 1: Creación Online
    test('createRecipe: Cuando hay conexión, guarda en local (unsynced) y luego actualiza (synced)', () async {
      fakeConnectivity.isOnline = true; // Simulamos que hay internet
      
      await repository.createRecipe(testRecipe);
      
      expect(fakeLocal.savedUnsynced, isTrue, reason: 'Debió hacer el guardado inicial preventivo');
      expect(fakeLocal.savedSynced, isTrue, reason: 'Debió actualizar el local tras subir a la nube');
    });

    // CASO 2: Creación Offline
    test('createRecipe: Cuando NO hay conexión, guarda en local y NO intenta subir a la nube', () async {
      fakeConnectivity.isOnline = false; // Le cortamos el internet
      
      await repository.createRecipe(testRecipe);
      
      expect(fakeLocal.savedUnsynced, isTrue, reason: 'Debe guardarlo localmente para no perder datos');
      expect(fakeLocal.savedSynced, isFalse, reason: 'No debe marcarlo como sincronizado');
    });

    // CASO 3: Fallback de Consultas
    test('getRecipesByUser: Si la nube falla, debe retornar silenciosamente los datos locales', () async {
      fakeConnectivity.isOnline = true;
      fakeRemote.failCloud = true; // Simulamos que se cayó Firebase
      
      final result = await repository.getRecipesByUser('usuario_1');
      
      // Comprobamos la etiqueta secreta de nuestro Fake para saber de dónde salió la info
      expect((result.first as FakeRecipe).id, 'receta_local_1', 
          reason: 'Al fallar la nube, el repositorio debe rescatar la información del disco local');
    });

    // CASO 4: Flujo de Eliminación Dual
    test('deleteRecipe: Debe borrar localmente (soft) y si la nube responde bien, borrar definitivamente (hard)', () async {
      fakeConnectivity.isOnline = true;
      
      await repository.deleteRecipe('123');
      
      expect(fakeLocal.softDeleteCalled, isTrue, reason: 'Ocultamiento inicial (Soft Delete)');
      expect(fakeRemote.deleteCalled, isTrue, reason: 'Eliminación en Firebase');
      expect(fakeLocal.hardDeleteCalled, isTrue, reason: 'Limpieza final del disco local tras éxito');
    });
    
  });
}