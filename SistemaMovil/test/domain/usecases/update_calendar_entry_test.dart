import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:Nutricional/domain/entities/calendar_entry.dart';
import 'package:Nutricional/domain/usecases/update_calendar_entry.dart';

import 'mocks/mock_calendar_repository.dart';

class FakeCalendarEntry extends Fake implements CalendarEntry {}

void main() {
  late MockCalendarRepository repository;
  late UpdateCalendarEntryUseCase useCase;

  setUp(() {
    repository = MockCalendarRepository();
    useCase = UpdateCalendarEntryUseCase(repository);
    registerFallbackValue(
      FakeCalendarEntry()
    );
  });

  group('UpdateCalendarEntryUseCase', () {

    // ============================================================
    // TIPO:
    // ✔ Unit Test
    // ✔ Mock Test
    // OBJETIVO:
    // Verificar actualización.
    // ============================================================
    test('Debe actualizar correctamente', () async {

      final entry = CalendarEntry(
        id: '1',
        userId: 'u1',
        recipeId: 'r1',
        recipeTitle: 'Pizza',
        recipeImageUrl: '',
        scheduledDate: DateTime.now(),
        mealType: 'lunch',
        createdAt: DateTime.now(),
      );

      when(() =>
          repository.updateEntry(entry))
          .thenAnswer((_) async {});

      await useCase(entry);

      verify(() =>
          repository.updateEntry(entry))
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
        mealType: 'lunch',
        createdAt: DateTime.now(),
      );

      when(() =>
          repository.updateEntry(any()))
          .thenThrow(Exception());

      expect(
        () => useCase(entry),
        throwsException,
      );
    });
  });
}