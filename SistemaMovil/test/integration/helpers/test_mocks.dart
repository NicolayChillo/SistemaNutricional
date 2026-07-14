import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 🔹 Importar los repositorios y servicios con package:
import 'package:Nutricional/domain/repositories/auth_repository.dart';
import 'package:Nutricional/domain/repositories/product_repository.dart';
import 'package:Nutricional/domain/repositories/recipe_repository.dart';
import 'package:Nutricional/domain/repositories/calendar_repository.dart';
import 'package:Nutricional/data/services/connectivity_service.dart';
import 'package:Nutricional/data/services/sync_service.dart';
import 'package:Nutricional/data/services/notification_service.dart';
import 'package:Nutricional/data/services/open_food_facts_service.dart';
import 'package:Nutricional/data/datasources/recipe_firebase_datasource.dart';
import 'package:Nutricional/data/datasources/product_firebase_datasource.dart';
import 'package:Nutricional/data/datasources/calendar_firebase_datasource.dart';
import 'package:Nutricional/data/datasources/local/recipe_local_datasource.dart';
import 'package:Nutricional/data/datasources/local/product_local_datasource.dart';
import 'package:Nutricional/data/datasources/local/calendar_local_datasource.dart';
import 'package:Nutricional/data/datasources/local/database_helper.dart';
import 'package:Nutricional/data/datasources/cloudinary_datasource.dart';
import 'test_data.dart';

// 🔹 Importar y exportar los mocks generados
import 'test_mocks.mocks.dart';
export 'test_mocks.mocks.dart';

// 🔹 Generar mocks
@GenerateMocks([
  AuthRepository,
  ProductRepository,
  RecipeRepository,
  CalendarRepository,
  ConnectivityService,
  SyncService,
  NotificationService,
  OpenFoodFactsService,
  RecipeFirebaseDatasource,
  ProductFirebaseDatasource,
  CalendarFirebaseDatasource,
  RecipeLocalDatasource,
  ProductLocalDatasource,
  CalendarLocalDatasource,
  DatabaseHelper,
  CloudinaryDatasource,
  Connectivity,
  FirebaseAuth,
  FirebaseFirestore,
])
void main() {}

// 🔹 Fábrica de mocks
class MockFactory {
  static MockAuthRepository createMockAuthRepository() {
    final mock = MockAuthRepository();
    when(mock.loginWithEmail(any, any))
        .thenAnswer((_) async => IntegrationTestData.testUser);
    when(mock.registerWithEmail(any, any, any))
        .thenAnswer((_) async => IntegrationTestData.testUser);
    when(mock.loginWithGoogle())
        .thenAnswer((_) async => IntegrationTestData.testUser);
    when(mock.loginWithFacebook())
        .thenAnswer((_) async => IntegrationTestData.testUser);
    when(mock.loginWithApi(any, any))
        .thenAnswer((_) async => IntegrationTestData.testUser);
    when(mock.logout()).thenAnswer((_) async {});
    when(mock.deleteAccount()).thenAnswer((_) async {});
    when(mock.getCurrentUser()).thenReturn(IntegrationTestData.testUser);
    when(mock.authStateChanges()).thenAnswer((_) => Stream.value(IntegrationTestData.testUser));
    return mock;
  }

  static MockProductRepository createMockProductRepository() {
    final mock = MockProductRepository();
    when(mock.createProduct(any))
        .thenAnswer((_) async => IntegrationTestData.testProduct);
    when(mock.getProductsByUser(any))
        .thenAnswer((_) async => [IntegrationTestData.testProduct, IntegrationTestData.testProduct2]);
    when(mock.getProductById(any))
        .thenAnswer((_) async => IntegrationTestData.testProduct);
    when(mock.getProductByBarcode(any))
        .thenAnswer((_) async => IntegrationTestData.testProduct);
    when(mock.updateProduct(any)).thenAnswer((_) async {});
    when(mock.deleteProduct(any)).thenAnswer((_) async {});
    return mock;
  }

  static MockRecipeRepository createMockRecipeRepository() {
    final mock = MockRecipeRepository();
    when(mock.createRecipe(any))
        .thenAnswer((_) async => IntegrationTestData.testRecipe);
    when(mock.getRecipesByUser(any))
        .thenAnswer((_) async => [IntegrationTestData.testRecipe, IntegrationTestData.testRecipe2]);
    when(mock.getAllRecipes())
        .thenAnswer((_) async => [IntegrationTestData.testRecipe, IntegrationTestData.testRecipe2]);
    when(mock.getRecipeById(any))
        .thenAnswer((_) async => IntegrationTestData.testRecipe);
    when(mock.updateRecipe(any)).thenAnswer((_) async {});
    when(mock.deleteRecipe(any)).thenAnswer((_) async {});
    return mock;
  }

  static MockCalendarRepository createMockCalendarRepository() {
    final mock = MockCalendarRepository();
    when(mock.createEntry(any))
        .thenAnswer((_) async => IntegrationTestData.testCalendarEntry);
    when(mock.getEntriesByUser(any))
        .thenAnswer((_) async => [IntegrationTestData.testCalendarEntry]);
    when(mock.getEntriesByDateRange(any, any, any))
        .thenAnswer((_) async => [IntegrationTestData.testCalendarEntry]);
    when(mock.getEntryById(any))
        .thenAnswer((_) async => IntegrationTestData.testCalendarEntry);
    when(mock.updateEntry(any)).thenAnswer((_) async {});
    when(mock.deleteEntry(any)).thenAnswer((_) async {});
    when(mock.syncAllFromCloud(any)).thenAnswer((_) async {});
    return mock;
  }

  static MockConnectivityService createMockConnectivityService({bool connected = true}) {
    final mock = MockConnectivityService();
    when(mock.isConnected).thenReturn(connected);
    when(mock.checkConnection()).thenAnswer((_) async => connected);
    when(mock.connectionStream).thenAnswer((_) => Stream.value(connected));
    // 🔹 waitForConnection no recibe argumentos en tu implementación real
    when(mock.waitForConnection()).thenAnswer((_) async {});
    return mock;
  }

  static MockSyncService createMockSyncService() {
    final mock = MockSyncService();
    when(mock.syncAll()).thenAnswer((_) async {});
    when(mock.syncRecipes()).thenAnswer((_) async {});
    when(mock.forceSyncNow()).thenAnswer((_) async {});
    when(mock.getPendingSyncCount()).thenAnswer((_) async => 0);
    // 🔹 startAutoSync no recibe argumentos en tu implementación real
    when(mock.startAutoSync()).thenReturn(null);
    when(mock.stopAutoSync()).thenReturn(null);
    return mock;
  }

  static MockNotificationService createMockNotificationService() {
    final mock = MockNotificationService();
    when(mock.initialize()).thenAnswer((_) async {});
    when(mock.scheduleNotification(any)).thenAnswer((_) async {});
    when(mock.cancelNotification(any)).thenAnswer((_) async {});
    when(mock.cancelAllNotifications()).thenAnswer((_) async {});
    when(mock.areNotificationsEnabled()).thenAnswer((_) async => true);
    when(mock.requestPermissions()).thenAnswer((_) async => true);
    return mock;
  }

  static MockOpenFoodFactsService createMockOpenFoodFactsService() {
    final mock = MockOpenFoodFactsService();
    when(mock.getProductByBarcode(any, any))
        .thenAnswer((_) async => IntegrationTestData.testProduct);
    return mock;
  }
}