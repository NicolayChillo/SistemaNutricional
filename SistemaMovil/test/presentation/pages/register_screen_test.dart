/*import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../../lib/presentation/pages/register_screen.dart';
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
          '/login': (_) => const Scaffold(
                body: Text('Pantalla Login'),
              ),
          '/home': (_) => const Scaffold(
                body: Text('Pantalla Home'),
              ),
        },
        home: const RegisterScreen(),
      ),
    );
  }

  group('RegisterScreen Presentation Tests', () {
    testWidgets(
      'Debe mostrar el título Crear Cuenta',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.text('Crear Cuenta'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar el título Regístrate',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.text('Regístrate'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar los tres campos del formulario',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.text('Nombre'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Contraseña'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar el botón Registrarse',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.text('Registrarse'), findsOneWidget);
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
      'Debe mostrar enlace para iniciar sesión',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(
          find.text('¿Ya tienes una cuenta? Inicia sesión'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe mostrar errores de validación con formulario vacío',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        await tester.tap(find.text('Registrarse'));
        await tester.pump();

        expect(
          find.text('Por favor ingrese su nombre'),
          findsOneWidget,
        );

        expect(
          find.text('Por favor ingrese su email'),
          findsOneWidget,
        );

        expect(
          find.text('Por favor ingrese su contraseña'),
          findsOneWidget,
        );
      },
    );
  });
}*/