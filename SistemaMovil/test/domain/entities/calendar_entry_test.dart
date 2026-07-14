import 'package:flutter_test/flutter_test.dart';
import 'package:Nutricional/domain/entities/calendar_entry.dart';

void main() {

  group('CalendarEntry Entity Tests', () {

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