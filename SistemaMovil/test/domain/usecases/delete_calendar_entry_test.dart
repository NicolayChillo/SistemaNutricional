import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:Nutricional/domain/usecases/delete_calendar_entry.dart';

import 'mocks/mock_calendar_repository.dart';

void main() {
  late MockCalendarRepository repository;
  late DeleteCalendarEntryUseCase useCase;

  setUp(() {
    repository = MockCalendarRepository();
    useCase = DeleteCalendarEntryUseCase(repository);
  });

  group('DeleteCalendarEntryUseCase', () {

    // ============================================================
    // TIPO:
    // ✔ Unit Test
    // ✔ Mock Test
    // OBJETIVO:
    // Verificar eliminación.
    // ============================================================
    test('Debe eliminar correctamente', () async {

      when(() =>
          repository.deleteEntry('1'))
          .thenAnswer((_) async {});

      await useCase('1');

      verify(() =>
          repository.deleteEntry('1'))
          .called(1);
    });

    // ============================================================
    // TIPO:
    // ✔ Exception Test
    // ============================================================
    test('Debe lanzar excepción', () async {

      when(() =>
          repository.deleteEntry(any()))
          .thenThrow(Exception());

      expect(
        () => useCase('1'),
        throwsException,
      );
    });
  });
}