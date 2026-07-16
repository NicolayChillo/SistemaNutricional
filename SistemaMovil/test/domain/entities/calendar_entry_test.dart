import 'package:flutter_test/flutter_test.dart';
import 'package:Nutricional/domain/entities/calendar_entry.dart';

void main() {

  group('CalendarEntry Entity Tests', () {

    // ==============================
    // TIPO DE PRUEBA:
    // Prueba Unitaria (Unit Test)
    // OBJETIVO:
    // Verificar que la entidad CalendarEntry
    // se construya correctamente y que los
    // valores por defecto funcionen.
    // ==============================

    test('Debe crear una entrada del calendario', () {

      final entry = CalendarEntry(
        id: '1',
        userId: 'user1',
        recipeId: 'recipe1',
        recipeTitle: 'Pizza',
        recipeImageUrl: '',
        scheduledDate: DateTime.now(),
        mealType: 'dinner',
        createdAt: DateTime.now(),
      );

      expect(entry.recipeTitle, 'Pizza');
      expect(entry.notificationSent, false);
      expect(entry.mealType, 'dinner');
    });
  });
}