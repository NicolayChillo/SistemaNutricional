import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/templates/main_template.dart';
import '../../../lib/presentation/theme/app_colors.dart';

void main() {
  Widget createTestWidget({
    Widget child = const Text('Contenido principal'),
    String title = 'Inicio',
    List<Widget>? actions,
    Widget? floatingActionButton,
    Widget? bottomNavigationBar,
  }) {
    return MaterialApp(
      home: MainTemplate(
        title: title,
        actions: actions,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
        child: child,
      ),
    );
  }

  group('MainTemplate Widget Tests', () {
    testWidgets(
      'Debe mostrar correctamente el título',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(title: 'Mis recetas'),
        );

        expect(find.text('Mis recetas'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar correctamente el widget hijo',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Contenido principal'), findsOneWidget);
      },
    );

    testWidgets(
  'Debe contener Scaffold AppBar y SafeArea',
  (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);

    final safeAreaFinder = find.descendant(
      of: find.byType(MainTemplate),
      matching: find.byType(SafeArea),
    );

    expect(safeAreaFinder, findsWidgets);
  },
);

    testWidgets(
      'Debe utilizar el color de fondo correcto',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final scaffold = tester.widget<Scaffold>(
          find.byType(Scaffold),
        );

        expect(scaffold.backgroundColor, AppColors.background);
      },
    );

    testWidgets(
      'AppBar debe utilizar hunterGreen y texto blanco',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final appBar = tester.widget<AppBar>(
          find.byType(AppBar),
        );

        expect(appBar.backgroundColor, AppColors.hunterGreen);
        expect(appBar.foregroundColor, Colors.white);
        expect(appBar.elevation, 0);
      },
    );

    testWidgets(
      'Debe mostrar las acciones proporcionadas',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            actions: const [
              IconButton(
                onPressed: null,
                icon: Icon(Icons.settings),
              ),
              IconButton(
                onPressed: null,
                icon: Icon(Icons.search),
              ),
            ],
          ),
        );

        expect(find.byIcon(Icons.settings), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar FloatingActionButton cuando es proporcionado',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ),
        );

        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
      },
    );

    testWidgets(
      'No debe mostrar FloatingActionButton cuando es null',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(FloatingActionButton), findsNothing);
      },
    );

    testWidgets(
      'Debe mostrar bottomNavigationBar cuando es proporcionado',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            bottomNavigationBar: const BottomAppBar(
              child: Text('Navegación inferior'),
            ),
          ),
        );

        expect(find.byType(BottomAppBar), findsOneWidget);
        expect(find.text('Navegación inferior'), findsOneWidget);
      },
    );

    testWidgets(
      'No debe mostrar BottomAppBar cuando no es proporcionado',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(BottomAppBar), findsNothing);
      },
    );
  });
}