import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:Nutricional/domain/entities/calendar_entry.dart';
import 'package:Nutricional/domain/usecases/create_calendar_entry.dart';

import 'mocks/mock_calendar_repository.dart';

class FakeCalendarEntry extends Fake implements CalendarEntry{}

void main() {
  late MockCalendarRepository repository;
  late CreateCalendarEntryUseCase useCase;

  setUp(() {
    repository = MockCalendarRepository();
    useCase = CreateCalendarEntryUseCase(repository);
    registerFallbackValue(
      FakeCalendarEntry(),
    );
  });

  group('CreateCalendarEntryUseCase', () {

    // ============================================================
    // TIPO:
    // ✔ Unit Test
    // ✔ Mock Test
    // OBJETIVO:
    // Verificar creación correcta de una entrada.
    // ============================================================
    test('Debe crear una entrada correctamente', () async {

      // Arrange
      final entry = CalendarEntry(
        id: '1',
        userId: 'u1',
        recipeId: 'r1',
        recipeTitle: 'Pizza',
        recipeImageUrl: '',
        scheduledDate: DateTime.now(),
        mealType: 'dinner',
        createdAt: DateTime.now(),
      );

      when(() => repository.createEntry(entry))
          .thenAnswer((_) async => entry);

      // Act
      final result = await useCase(entry);

      // Assert
      expect(result.id, '1');

      verify(() =>
          repository.createEntry(entry))
          .called(1);
    });

    // ============================================================
    // TIPO:
    // ✔ Exception Test
    // ============================================================
    test('Debe lanzar excepción', () async {

      final entry = CalendarEntry(
        id: '1',
        userId: 'u1',
        recipeId: 'r1',
        recipeTitle: 'Pizza',
        recipeImageUrl: '',
        scheduledDate: DateTime.now(),
        mealType: 'dinner',
        createdAt: DateTime.now(),
      );

      when(() =>
          repository.createEntry(any()))
          .thenThrow(Exception());

      expect(
        () => useCase(entry),
        throwsException,
      );
    });
  });
}