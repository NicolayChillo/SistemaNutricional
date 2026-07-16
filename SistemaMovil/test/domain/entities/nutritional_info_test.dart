import 'package:flutter_test/flutter_test.dart';
import 'package:Nutricional/domain/entities/nutritional_info.dart';

void main() {

  group('NutritionalInfo Entity Tests', () {

    // ==========================================
    // TIPO DE PRUEBA:
    // Prueba Unitaria (Unit Test)
    // OBJETIVO:
    // Validar la creación de la entidad,
    // serialización JSON y valores por defecto.
    // ==========================================

    test('Debe crear correctamente la información nutricional', () {

      final nutrition = NutritionalInfo(
        calories: 100,
        protein: 10,
        carbohydrates: 20,
        fat: 5,
      );

      expect(nutrition.calories, 100);
      expect(nutrition.fiber, 0);
      expect(nutrition.servingSize, '100g');
    });

    // ==========================================
    // TIPO:
    // Prueba Unitaria de Serialización
    // OBJETIVO:
    // Verificar conversión a JSON.
    // ==========================================
    test('Debe convertir a JSON', () {

      final nutrition = NutritionalInfo(
        calories: 100,
        protein: 10,
        carbohydrates: 20,
        fat: 5,
      );

      final json = nutrition.toJson();

      expect(json['calories'], 100);
      expect(json['protein'], 10);
    });

    // ==========================================
    // TIPO:
    // Prueba Unitaria de Deserialización
    // OBJETIVO:
    // Verificar creación desde JSON.
    // ==========================================
    test('Debe crear desde JSON', () {

      final json = {
        'calories': 200,
        'protein': 30,
        'carbohydrates': 15,
        'fat': 10,
      };

      final nutrition = NutritionalInfo.fromJson(json);

      expect(nutrition.calories, 200);
      expect(nutrition.protein, 30);
      expect(nutrition.fat, 10);
    });

    // ==========================================
    // TIPO:
    // Prueba de Valores por Defecto
    // OBJETIVO:
    // Verificar manejo de datos faltantes.
    // ==========================================
    test('Debe usar valores por defecto cuando faltan datos', () {

      final nutrition =
          NutritionalInfo.fromJson({});

      expect(nutrition.calories, 0);
      expect(nutrition.servingSize, '100g');
    });
  });
}