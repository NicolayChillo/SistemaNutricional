import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/templates/recipe_template.dart';

void main() {
  Widget createTestWidget({
    Widget child = const Text('Contenido receta'),
    String title = 'Receta',
    String? subtitle,
    List<Widget>? actions,
    Widget? floatingActionButton,
    bool showBackButton = true,
    Widget? drawer,
  }) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
      ),
      home: RecipeTemplate(
        title: title,
        subtitle: subtitle,
        actions: actions,
        floatingActionButton: floatingActionButton,
        showBackButton: showBackButton,
        drawer: drawer,
        child: child,
      ),
    );
  }

  group('RecipeTemplate Widget Tests', () {
    testWidgets(
      'Debe mostrar correctamente el título',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(title: 'Pizza casera'),
        );

        expect(find.text('Pizza casera'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar correctamente el widget hijo',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Contenido receta'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar subtítulo cuando es proporcionado',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            subtitle: 'Una deliciosa receta',
          ),
        );

        expect(
          find.text('Una deliciosa receta'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'No debe mostrar subtítulo cuando es null',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(AppBar), findsOneWidget);

        final appBar = tester.widget<AppBar>(
          find.byType(AppBar),
        );

        final titleColumn = appBar.title as Column;

        expect(titleColumn.children.length, 1);
      },
    );

    testWidgets(
      'No debe mostrar subtítulo cuando está vacío',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(subtitle: ''),
        );

        final appBar = tester.widget<AppBar>(
          find.byType(AppBar),
        );

        final titleColumn = appBar.title as Column;

        expect(titleColumn.children.length, 1);
      },
    );

    testWidgets(
      'Debe configurar showBackButton en true',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(showBackButton: true),
        );

        final appBar = tester.widget<AppBar>(
          find.byType(AppBar),
        );

        expect(appBar.automaticallyImplyLeading, isTrue);
      },
    );

    testWidgets(
      'Debe configurar showBackButton en false',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(showBackButton: false),
        );

        final appBar = tester.widget<AppBar>(
          find.byType(AppBar),
        );

        expect(appBar.automaticallyImplyLeading, isFalse);
      },
    );

    testWidgets(
      'Debe mostrar las acciones proporcionadas',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            actions: const [
              Icon(Icons.edit),
              Icon(Icons.delete),
            ],
          ),
        );

        expect(find.byIcon(Icons.edit), findsOneWidget);
        expect(find.byIcon(Icons.delete), findsOneWidget);
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
      'Debe mostrar drawer cuando es proporcionado',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            drawer: const Drawer(
              child: Text('Mi Drawer'),
            ),
          ),
        );

        final scaffold = tester.widget<Scaffold>(
          find.byType(Scaffold),
        );

        expect(scaffold.drawer, isNotNull);
      },
    );

    testWidgets(
      'Debe mostrar botón de menú con drawer y sin botón atrás',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            showBackButton: false,
            drawer: const Drawer(
              child: Text('Mi Drawer'),
            ),
          ),
        );

        expect(find.byIcon(Icons.menu), findsOneWidget);
      },
    );

    testWidgets(
      'Botón de menú debe abrir el drawer',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            showBackButton: false,
            drawer: const Drawer(
              child: Text('Contenido Drawer'),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();

        expect(find.text('Contenido Drawer'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe usar los colores del tema en AppBar',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final BuildContext context = tester.element(
          find.byType(RecipeTemplate),
        );

        final colorScheme = Theme.of(context).colorScheme;

        final appBar = tester.widget<AppBar>(
          find.byType(AppBar),
        );

        expect(
          appBar.backgroundColor,
          colorScheme.primary,
        );

        expect(
          appBar.foregroundColor,
          colorScheme.onPrimary,
        );

        expect(appBar.elevation, 0);
      },
    );
  });
}