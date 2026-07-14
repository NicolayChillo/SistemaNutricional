import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/atoms/primary_button.dart';

void main() {
  group('PrimaryButton Widget Tests', () {
    testWidgets(
      'Debe mostrar correctamente el texto del botón',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: PrimaryButton(
                text: 'Iniciar sesión',
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Iniciar sesión'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      },
    );

    testWidgets(
      'Debe ejecutar onPressed al presionar el botón',
      (WidgetTester tester) async {
        // Arrange
        bool fuePresionado = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PrimaryButton(
                text: 'Continuar',
                onPressed: () {
                  fuePresionado = true;
                },
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // Assert
        expect(fuePresionado, isTrue);
      },
    );

    testWidgets(
      'Debe mostrar indicador de carga cuando isLoading es true',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: PrimaryButton(
                text: 'Cargando',
                isLoading: true,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Cargando'), findsNothing);
      },
    );

    testWidgets(
      'Debe mostrar un icono cuando se proporciona',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: PrimaryButton(
                text: 'Guardar',
                icon: Icons.save,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.save), findsOneWidget);
        expect(find.text('Guardar'), findsOneWidget);
      },
    );
  });
}