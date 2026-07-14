import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_data.dart';
import '../helpers/test_mocks.dart';
import '../helpers/test_helpers.dart';
import 'package:Nutricional/domain/usecases/create_calendar_entry.dart';
import 'package:Nutricional/domain/usecases/get_calendar_entries.dart';
import 'package:Nutricional/domain/usecases/update_calendar_entry.dart';
import 'package:Nutricional/domain/usecases/delete_calendar_entry.dart';

import 'package:Nutricional/domain/entities/calendar_entry.dart';

void main() {
  late MockCalendarRepository mockCalendarRepo;
  late CreateCalendarEntryUseCase createEntry;
  late GetCalendarEntriesUseCase getEntries;
  late UpdateCalendarEntryUseCase updateEntry;
  late DeleteCalendarEntryUseCase deleteEntry;

  const testUserId = 'int_user_001';

  setUp(() {
    mockCalendarRepo = MockFactory.createMockCalendarRepository();
    createEntry = CreateCalendarEntryUseCase(mockCalendarRepo);
    getEntries = GetCalendarEntriesUseCase(mockCalendarRepo);
    updateEntry = UpdateCalendarEntryUseCase(mockCalendarRepo);
    deleteEntry = DeleteCalendarEntryUseCase(mockCalendarRepo);
  });

  tearDown(() {
    resetMocks([mockCalendarRepo]);
  });

  test('CRUD completo de entrada de calendario', () async {
    final newEntry = IntegrationTestData.testCalendarEntry;
    final entryWithId = CalendarEntry(
      id: 'new_cal_001',
      userId: newEntry.userId,
      recipeId: newEntry.recipeId,
      recipeTitle: newEntry.recipeTitle,
      recipeImageUrl: newEntry.recipeImageUrl,
      scheduledDate: newEntry.scheduledDate,
      mealType: newEntry.mealType,
      notificationSent: newEntry.notificationSent,
      createdAt: DateTime.now(),
    );

    when(mockCalendarRepo.createEntry(any))
        .thenAnswer((_) async => entryWithId);

    final created = await createEntry(entryWithId);
    // Sobrescribir el mock para que devuelva la lista con el elemento creado
    when(mockCalendarRepo.getEntriesByUser(testUserId))
        .thenAnswer((_) async => [created]);
    expect(created.id, isNotEmpty);
    expect(created.recipeTitle, equals(newEntry.recipeTitle));
    verify(mockCalendarRepo.createEntry(any)).called(1);

    final entries = await getEntries.callByUser(testUserId);
    expect(entries, isNotEmpty);
    expect(entries.any((e) => e.id == created.id), true);
    verify(mockCalendarRepo.getEntriesByUser(testUserId)).called(1);

    final updatedEntry = CalendarEntry(
      id: created.id,
      userId: created.userId,
      recipeId: created.recipeId,
      recipeTitle: 'Receta Actualizada Calendario',
      recipeImageUrl: created.recipeImageUrl,
      scheduledDate: DateTime(2024, 1, 16, 13, 0),
      mealType: 'lunch',
      notificationSent: false,
      createdAt: created.createdAt,
    );

    when(mockCalendarRepo.updateEntry(updatedEntry))
        .thenAnswer((_) async {});
    await updateEntry(updatedEntry);
    when(mockCalendarRepo.getEntriesByUser(testUserId))
        .thenAnswer((_) async => [updatedEntry]);
    verify(mockCalendarRepo.updateEntry(updatedEntry)).called(1);

    when(mockCalendarRepo.deleteEntry(created.id))
        .thenAnswer((_) async {});
    when(mockCalendarRepo.getEntriesByUser(testUserId))
        .thenAnswer((_) async => []);
    await deleteEntry(created.id);
    verify(mockCalendarRepo.deleteEntry(created.id)).called(1);

    final afterDeletion = await getEntries.callByUser(testUserId);
    expect(afterDeletion.any((e) => e.id == created.id), false);
  });
}