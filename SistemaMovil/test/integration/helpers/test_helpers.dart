import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Importar las entidades
import 'package:Nutricional/domain/entities/product.dart';
import 'package:Nutricional/domain/entities/recipe.dart';

void resetMocks(List<dynamic> mocks) {
  for (final mock in mocks) {
    reset(mock);
  }
}

Future<void> waitForAsync() async {
  await Future.delayed(const Duration(milliseconds: 100));
}

bool recipesEqualIgnoringOrder(List<Recipe> a, List<Recipe> b) {
  if (a.length != b.length) return false;
  final sortedA = [...a]..sort((x, y) => x.id.compareTo(y.id));
  final sortedB = [...b]..sort((x, y) => x.id.compareTo(y.id));
  for (int i = 0; i < sortedA.length; i++) {
    if (sortedA[i].id != sortedB[i].id) return false;
  }
  return true;
}

bool productsEqualIgnoringOrder(List<Product> a, List<Product> b) {
  if (a.length != b.length) return false;
  final sortedA = [...a]..sort((x, y) => x.id.compareTo(y.id));
  final sortedB = [...b]..sort((x, y) => x.id.compareTo(y.id));
  for (int i = 0; i < sortedA.length; i++) {
    if (sortedA[i].id != sortedB[i].id) return false;
  }
  return true;
}