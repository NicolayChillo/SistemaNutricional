import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_data.dart';

void main() {
  test('Carga de 1000 productos', () {
    final stopwatch = Stopwatch()..start();
    final products = IntegrationTestData.generateBulkProducts(1000);
    stopwatch.stop();
    expect(products.length, 1000);
    expect(stopwatch.elapsedMilliseconds, lessThan(10000));
  });

  test('Carga de 500 recetas', () {
    final stopwatch = Stopwatch()..start();
    final recipes = IntegrationTestData.generateBulkRecipes(500);
    stopwatch.stop();
    expect(recipes.length, 500);
    expect(stopwatch.elapsedMilliseconds, lessThan(8000));
  });

  test('Carga de 200 entradas de calendario', () {
    final stopwatch = Stopwatch()..start();
    final entries = IntegrationTestData.generateBulkCalendarEntries(200, 'int_user_001');
    stopwatch.stop();
    expect(entries.length, 200);
    expect(stopwatch.elapsedMilliseconds, lessThan(5000));
  });

  test('Procesamiento concurrente de 100 operaciones', () async {
    final stopwatch = Stopwatch()..start();
    final futures = List.generate(100, (index) async {
      await Future.delayed(const Duration(milliseconds: 50));
      return index;
    });
    final results = await Future.wait(futures);
    stopwatch.stop();
    expect(results.length, 100);
    expect(stopwatch.elapsedMilliseconds, lessThan(10000));
  });
}