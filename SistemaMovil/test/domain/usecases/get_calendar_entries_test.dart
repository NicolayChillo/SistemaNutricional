import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:Nutricional/domain/entities/calendar_entry.dart';
import 'package:Nutricional/domain/usecases/get_calendar_entries.dart';

import 'mocks/mock_calendar_repository.dart';

void main() {
  late MockCalendarRepository repository;
  late GetCalendarEntriesUseCase useCase;

  setUp(() {
    repository = MockCalendarRepository();
    useCase = GetCalendarEntriesUseCase(repository);
  });

  group('GetCalendarEntriesUseCase', () {

    // ============================================================
    // TIPO:
    // ✔ Unit Test
    // ✔ Mock Test
    // OBJETIVO:
    // Obtener lista de entradas.
    // ============================================================
    test('Debe obtener entradas por usuario', () async {

      final entries = <CalendarEntry>[];

      when(() =>
          repository.getEntriesByUser('u1'))
          .thenAnswer((_) async => entries);

      final result =
          await useCase.callByUser('u1');

      expect(result, entries);

      verify(() =>
          repository.getEntriesByUser('u1'))
          .called(1);
    });

    // ============================================================
    // TIPO:
    // ✔ Lista Vacía
    // ============================================================
    test('Debe devolver lista vacía', () async {

      when(() =>
          repository.getEntriesByUser(any()))
          .thenAnswer((_) async => []);

      final result =
          await useCase.callByUser('u1');

      expect(result.isEmpty, true);
    });

    // ============================================================
    // TIPO:
    // ✔ Unit Test
    // ✔ Mock Test
    // OBJETIVO:
    // Obtener por rango de fechas.
    // ============================================================
    test('Debe obtener entradas por rango', () async {

      final start =
          DateTime(2026, 1, 1);

      final end =
          DateTime(2026, 1, 31);

      when(() =>
          repository.getEntriesByDateRange(
              'u1',
              start,
              end))
          .thenAnswer((_) async => []);

      final result =
          await useCase.callByDateRange(
              'u1',
              start,
              end);

      expect(result, isA<List>());
    });

    // ============================================================
    // TIPO:
    // ✔ Exception Test
    // ============================================================
    test('Debe lanzar excepción', () async {

      when(() =>
          repository.getEntriesByUser(any()))
          .thenThrow(Exception());

      expect(
        () => useCase.callByUser('u1'),
        throwsException,
      );
    });
  });
}