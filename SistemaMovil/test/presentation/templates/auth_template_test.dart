import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/templates/auth_template.dart';
import '../../../lib/presentation/theme/app_colors.dart';

void main() {
  Widget createTestWidget({
    Widget child = const Text('Contenido de prueba'),
    String? appBarTitle,
    bool showBackButton = false,
  }) {
    return MaterialApp(
      home: AuthTemplate(
        appBarTitle: appBarTitle,
        showBackButton: showBackButton,
        child: child,
      ),
    );
  }

  group('AuthTemplate Widget Tests', () {
    testWidgets(
      'Debe mostrar correctamente el widget hijo',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Contenido de prueba'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe contener Scaffold SafeArea y SingleChildScrollView',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      },
    );

    testWidgets(
      'No debe mostrar AppBar cuando appBarTitle es null',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(AppBar), findsNothing);
      },
    );

    testWidgets(
      'Debe mostrar AppBar cuando existe appBarTitle',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(appBarTitle: 'Iniciar sesión'),
        );

        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Iniciar sesión'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe configurar correctamente showBackButton en false',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            appBarTitle: 'Login',
            showBackButton: false,
          ),
        );

        final appBar = tester.widget<AppBar>(find.byType(AppBar));

        expect(appBar.automaticallyImplyLeading, isFalse);
      },
    );

    testWidgets(
      'Debe configurar correctamente showBackButton en true',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            appBarTitle: 'Login',
            showBackButton: true,
          ),
        );

        final appBar = tester.widget<AppBar>(find.byType(AppBar));

        expect(appBar.automaticallyImplyLeading, isTrue);
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
      'Debe utilizar padding de 24',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final scrollView = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView),
        );

        expect(
          scrollView.padding,
          const EdgeInsets.all(24.0),
        );
      },
    );

    testWidgets(
      'AppBar debe usar hunterGreen y texto blanco',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(appBarTitle: 'Autenticación'),
        );

        final appBar = tester.widget<AppBar>(
          find.byType(AppBar),
        );

        expect(appBar.backgroundColor, AppColors.hunterGreen);
        expect(appBar.foregroundColor, Colors.white);
        expect(appBar.elevation, 0);
      },
    );
  });
}