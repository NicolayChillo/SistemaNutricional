import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../../lib/presentation/molecules/sync_banner.dart';
import '../../../lib/presentation/providers/recipe_provider.dart';

class MockRecipeProvider extends Mock implements RecipeProvider {}

void main() {
  late MockRecipeProvider mockRecipeProvider;

  setUp(() {
    mockRecipeProvider = MockRecipeProvider();

    when(() => mockRecipeProvider.addListener(any()))
        .thenAnswer((_) {});

    when(() => mockRecipeProvider.removeListener(any()))
        .thenAnswer((_) {});
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<RecipeProvider>.value(
          value: mockRecipeProvider,
          child: const SyncBanner(),
        ),
      ),
    );
  }

  group('SyncBanner Widget Tests', () {
    testWidgets(
      'No debe mostrar banner cuando está online',
      (WidgetTester tester) async {
        when(() => mockRecipeProvider.isOnline).thenReturn(true);
        when(() => mockRecipeProvider.pendingSyncCount).thenReturn(5);

        await tester.pumpWidget(createTestWidget());

        expect(find.byType(SyncBanner), findsOneWidget);
        expect(find.byIcon(Icons.info_outline), findsNothing);
        expect(
          find.text('Tienes 5 cambio(s) sin sincronizar'),
          findsNothing,
        );
      },
    );

    testWidgets(
      'No debe mostrar banner cuando no hay cambios pendientes',
      (WidgetTester tester) async {
        when(() => mockRecipeProvider.isOnline).thenReturn(false);
        when(() => mockRecipeProvider.pendingSyncCount).thenReturn(0);

        await tester.pumpWidget(createTestWidget());

        expect(find.byIcon(Icons.info_outline), findsNothing);
        expect(
          find.textContaining('sin sincronizar'),
          findsNothing,
        );
      },
    );

    testWidgets(
      'Debe mostrar banner offline cuando existen cambios pendientes',
      (WidgetTester tester) async {
        when(() => mockRecipeProvider.isOnline).thenReturn(false);
        when(() => mockRecipeProvider.pendingSyncCount).thenReturn(3);

        await tester.pumpWidget(createTestWidget());

        expect(find.byIcon(Icons.info_outline), findsOneWidget);
        expect(
          find.text('Tienes 3 cambio(s) sin sincronizar'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe mostrar correctamente diferentes cantidades pendientes',
      (WidgetTester tester) async {
        when(() => mockRecipeProvider.isOnline).thenReturn(false);
        when(() => mockRecipeProvider.pendingSyncCount).thenReturn(10);

        await tester.pumpWidget(createTestWidget());

        expect(
          find.text('Tienes 10 cambio(s) sin sincronizar'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'No debe mostrar botón Sincronizar en estado offline',
      (WidgetTester tester) async {
        when(() => mockRecipeProvider.isOnline).thenReturn(false);
        when(() => mockRecipeProvider.pendingSyncCount).thenReturn(4);

        await tester.pumpWidget(createTestWidget());

        expect(find.text('Sincronizar'), findsNothing);
        expect(find.byIcon(Icons.sync), findsNothing);
      },
    );
  });
}