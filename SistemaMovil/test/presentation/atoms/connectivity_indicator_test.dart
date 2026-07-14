import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../../lib/presentation/atoms/connectivity_indicator.dart';
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
          child: const ConnectivityIndicator(),
        ),
      ),
    );
  }

  group('ConnectivityIndicator Widget Tests', () {
    testWidgets(
      'No debe mostrar indicador cuando está online y no hay sincronizaciones pendientes',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockRecipeProvider.isOnline).thenReturn(true);
        when(() => mockRecipeProvider.pendingSyncCount).thenReturn(0);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ConnectivityIndicator), findsOneWidget);
        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.text('Sin conexión'), findsNothing);
        expect(find.byIcon(Icons.cloud_off), findsNothing);
        expect(find.byIcon(Icons.sync), findsNothing);
      },
    );

    testWidgets(
      'Debe mostrar Sin conexión cuando está offline',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockRecipeProvider.isOnline).thenReturn(false);
        when(() => mockRecipeProvider.pendingSyncCount).thenReturn(0);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('Sin conexión'), findsOneWidget);
        expect(find.byIcon(Icons.cloud_off), findsOneWidget);
        expect(find.byIcon(Icons.sync), findsNothing);
      },
    );

    testWidgets(
      'Debe mostrar cantidad de sincronizaciones pendientes cuando está online',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockRecipeProvider.isOnline).thenReturn(true);
        when(() => mockRecipeProvider.pendingSyncCount).thenReturn(3);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(
          find.text('Sincronizando... (3)'),
          findsOneWidget,
        );

        expect(find.byIcon(Icons.sync), findsOneWidget);
        expect(find.byIcon(Icons.cloud_off), findsNothing);
      },
    );

    testWidgets(
      'Debe mostrar correctamente una cantidad diferente de pendientes',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockRecipeProvider.isOnline).thenReturn(true);
        when(() => mockRecipeProvider.pendingSyncCount).thenReturn(10);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(
          find.text('Sincronizando... (10)'),
          findsOneWidget,
        );

        expect(find.byIcon(Icons.sync), findsOneWidget);
      },
    );
  });
}