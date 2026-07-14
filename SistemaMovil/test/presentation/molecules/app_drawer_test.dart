import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/molecules/app_drawer.dart';

void main() {
  group('AppDrawer Widget Tests', () {
    testWidgets(
      'Debe mostrar nombre y email del usuario',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              drawer: AppDrawer(
                username: 'Sebastián',
                email: 'sebastian@correo.com',
              ),
            ),
          ),
        );

        final ScaffoldState scaffoldState =
            tester.state<ScaffoldState>(find.byType(Scaffold));

        scaffoldState.openDrawer();
        await tester.pumpAndSettle();

        expect(find.text('Sebastián'), findsOneWidget);
        expect(find.text('sebastian@correo.com'), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar Usuario por defecto cuando no se proporciona nombre',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              drawer: AppDrawer(),
            ),
          ),
        );

        final ScaffoldState scaffoldState =
            tester.state<ScaffoldState>(find.byType(Scaffold));

        scaffoldState.openDrawer();
        await tester.pumpAndSettle();

        expect(find.text('Usuario'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar todas las opciones de navegación',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              drawer: AppDrawer(),
            ),
          ),
        );

        final ScaffoldState scaffoldState =
            tester.state<ScaffoldState>(find.byType(Scaffold));

        scaffoldState.openDrawer();
        await tester.pumpAndSettle();

        expect(find.text('Inicio'), findsOneWidget);
        expect(find.text('Calendario Semanal'), findsOneWidget);
        expect(find.text('Mis Recetas'), findsOneWidget);
        expect(find.text('Productos'), findsOneWidget);
        expect(find.text('Configuración'), findsOneWidget);
        expect(find.text('Cerrar Sesión'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe ejecutar callback de Inicio',
      (WidgetTester tester) async {
        bool fuePresionado = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              drawer: AppDrawer(
                onHomePressed: () {
                  fuePresionado = true;
                },
              ),
            ),
          ),
        );

        final ScaffoldState scaffoldState =
            tester.state<ScaffoldState>(find.byType(Scaffold));

        scaffoldState.openDrawer();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Inicio'));
        await tester.pump();

        expect(fuePresionado, isTrue);
      },
    );

    testWidgets(
      'Debe ejecutar callback de Calendario Semanal',
      (WidgetTester tester) async {
        bool fuePresionado = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              drawer: AppDrawer(
                onCalendarPressed: () {
                  fuePresionado = true;
                },
              ),
            ),
          ),
        );

        final ScaffoldState scaffoldState =
            tester.state<ScaffoldState>(find.byType(Scaffold));

        scaffoldState.openDrawer();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Calendario Semanal'));
        await tester.pump();

        expect(fuePresionado, isTrue);
      },
    );

    testWidgets(
      'Debe ejecutar callback de Mis Recetas',
      (WidgetTester tester) async {
        bool fuePresionado = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              drawer: AppDrawer(
                onRecipesPressed: () {
                  fuePresionado = true;
                },
              ),
            ),
          ),
        );

        final ScaffoldState scaffoldState =
            tester.state<ScaffoldState>(find.byType(Scaffold));

        scaffoldState.openDrawer();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Mis Recetas'));
        await tester.pump();

        expect(fuePresionado, isTrue);
      },
    );

    testWidgets(
      'Debe ejecutar callback de Productos',
      (WidgetTester tester) async {
        bool fuePresionado = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              drawer: AppDrawer(
                onProductsPressed: () {
                  fuePresionado = true;
                },
              ),
            ),
          ),
        );

        final ScaffoldState scaffoldState =
            tester.state<ScaffoldState>(find.byType(Scaffold));

        scaffoldState.openDrawer();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Productos'));
        await tester.pump();

        expect(fuePresionado, isTrue);
      },
    );

    testWidgets(
      'Debe ejecutar callback de Configuración',
      (WidgetTester tester) async {
        bool fuePresionado = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              drawer: AppDrawer(
                onSettingsPressed: () {
                  fuePresionado = true;
                },
              ),
            ),
          ),
        );

        final ScaffoldState scaffoldState =
            tester.state<ScaffoldState>(find.byType(Scaffold));

        scaffoldState.openDrawer();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Configuración'));
        await tester.pump();

        expect(fuePresionado, isTrue);
      },
    );

    testWidgets(
      'Debe ejecutar callback de Cerrar Sesión',
      (WidgetTester tester) async {
        bool fuePresionado = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              drawer: AppDrawer(
                onLogoutPressed: () {
                  fuePresionado = true;
                },
              ),
            ),
          ),
        );

        final ScaffoldState scaffoldState =
            tester.state<ScaffoldState>(find.byType(Scaffold));

        scaffoldState.openDrawer();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cerrar Sesión'));
        await tester.pump();

        expect(fuePresionado, isTrue);
      },
    );
  });
}