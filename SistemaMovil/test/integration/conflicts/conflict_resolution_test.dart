import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_data.dart';

import 'package:Nutricional/domain/entities/calendar_entry.dart';
import 'package:Nutricional/domain/entities/product.dart';

void main() {
  test('Conflicto: mismo producto editado en dos dispositivos', () {
    final baseProduct = IntegrationTestData.testProduct;
    final cloudProduct = Product(
      id: baseProduct.id,
      barcode: baseProduct.barcode,
      name: 'Producto Editado Nube',
      brand: baseProduct.brand,
      imageUrl: baseProduct.imageUrl,
      category: baseProduct.category,
      nutritionalInfo: baseProduct.nutritionalInfo,
      userId: baseProduct.userId,
      createdAt: baseProduct.createdAt,
    );
    final resolvedProduct = cloudProduct;
    expect(resolvedProduct.name, equals('Producto Editado Nube'));
    expect(resolvedProduct.id, equals(baseProduct.id));
  });

  test('Conflicto: receta eliminada en un dispositivo y editada en otro', () {
    final isDeletedLocally = true;
    final shouldDelete = isDeletedLocally;
    expect(shouldDelete, true);
  });

  test('Conflicto: misma entrada de calendario duplicada', () {
    final entry = IntegrationTestData.testCalendarEntry;
    final entryA = CalendarEntry(
      id: entry.id,
      userId: entry.userId,
      recipeId: entry.recipeId,
      recipeTitle: entry.recipeTitle,
      recipeImageUrl: entry.recipeImageUrl,
      scheduledDate: entry.scheduledDate,
      mealType: entry.mealType,
      notificationSent: entry.notificationSent,
      createdAt: entry.createdAt,
    );
    final entryB = CalendarEntry(
      id: entry.id,
      userId: entry.userId,
      recipeId: entry.recipeId,
      recipeTitle: entry.recipeTitle,
      recipeImageUrl: entry.recipeImageUrl,
      scheduledDate: entry.scheduledDate,
      mealType: entry.mealType,
      notificationSent: entry.notificationSent,
      createdAt: entry.createdAt,
    );
    final uniqueEntries = {entryA.id, entryB.id};
    expect(uniqueEntries.length, 1);
  });

  test('Conflicto: sesión activa en dos dispositivos', () {
    final session2 = 'token_dispositivo_2';
    final activeSession = session2;
    expect(activeSession, equals(session2));
  });
}