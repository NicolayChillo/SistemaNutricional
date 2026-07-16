import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_data.dart';

void main() {
  test('Estrés: 10,000 productos en memoria', () {
    final stopwatch = Stopwatch()..start();
    final products = IntegrationTestData.generateBulkProducts(10000);
    stopwatch.stop();
    expect(products.length, 10000);
    expect(() => products.toString(), returnsNormally);
  });

  test('Estrés: 5,000 recetas en memoria', () {
    final stopwatch = Stopwatch()..start();
    final recipes = IntegrationTestData.generateBulkRecipes(5000);
    stopwatch.stop();
    expect(recipes.length, 5000);
  });

  test('Estrés: ordenar 50,000 números', () {
    final stopwatch = Stopwatch()..start();
    final numbers = List.generate(50000, (index) => index);
    final shuffled = numbers..shuffle();
    final sorted = shuffled..sort();
    stopwatch.stop();
    expect(sorted.length, 50000);
  });

  test('Estrés: objetos anidados complejos', () {
    final stopwatch = Stopwatch()..start();
    final complexData = List.generate(1000, (index) {
      return {
        'id': index,
        'name': 'Item $index',
        'metadata': {
          'created': DateTime.now().toIso8601String(),
          'tags': ['tag1', 'tag2', 'tag3'],
          'values': List.generate(10, (i) => i * index),
        },
        'nested': List.generate(5, (i) => {
          'sub_id': i,
          'data': 'Nested data $i',
        }),
      };
    });
    stopwatch.stop();
    expect(complexData.length, 1000);
  });
}