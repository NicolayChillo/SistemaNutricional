/*import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../../lib/presentation/pages/login_screen.dart';
import '../../../lib/presentation/providers/auth_provider.dart';

class TestAuthProvider extends AuthProvider {
  @override
  bool get isLoading => false;

  @override
  bool get isAuthenticated => false;

  @override
  String? get errorMessage => null;
}

void main() {
  Widget createTestWidget() {
    return ChangeNotifierProvider<AuthProvider>(
      create: (_) => TestAuthProvider(),
      child: MaterialApp(
        routes: {
          '/register': (_) => const Scaffold(
                body: Text('Pantalla Registro'),
              ),
          '/home': (_) => const Scaffold(
                body: Text('Pantalla Home'),
              ),
        },
        home: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen Presentation Tests', () {
    testWidgets(
      'Debe mostrar el título Iniciar Sesión',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.text('Iniciar Sesión'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar el mensaje de bienvenida',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.text('Bienvenido'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar los campos de email y contraseña',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Contraseña'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar el botón de iniciar sesión',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.text('Iniciar Sesión'), findsWidgets);
      },
    );

    testWidgets(
      'Debe mostrar los botones sociales',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.text('Google'), findsOneWidget);
        expect(find.text('Facebook'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar enlace para registrarse',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(
          find.text('¿No tienes una cuenta? Regístrate'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe mostrar términos y condiciones',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(
          find.text('Términos y Condiciones'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe navegar a registro al presionar el enlace',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        await tester.tap(
          find.text('¿No tienes una cuenta? Regístrate'),
        );

        await tester.pumpAndSettle();

        expect(find.text('Pantalla Registro'), findsOneWidget);
      },
    );
  });
}*/