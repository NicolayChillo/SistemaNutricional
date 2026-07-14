import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/atoms/custom_text_field.dart';

void main() {
  group('CustomTextField Widget Tests', () {
    testWidgets(
      'Debe mostrar correctamente label y hint',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CustomTextField(
                label: 'Correo electrónico',
                hint: 'Ingrese su correo',
              ),
            ),
          ),
        );

        expect(find.byType(CustomTextField), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Correo electrónico'), findsOneWidget);
        expect(find.text('Ingrese su correo'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe utilizar correctamente el controller',
      (WidgetTester tester) async {
        final controller = TextEditingController(
          text: 'Texto inicial',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomTextField(
                controller: controller,
              ),
            ),
          ),
        );

        expect(find.text('Texto inicial'), findsOneWidget);

        await tester.enterText(
          find.byType(TextFormField),
          'Nuevo texto',
        );

        expect(controller.text, 'Nuevo texto');

        controller.dispose();
      },
    );

    testWidgets(
      'Debe ocultar el texto cuando obscureText es true',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CustomTextField(
                obscureText: true,
              ),
            ),
          ),
        );

        final EditableText editableText = tester.widget<EditableText>(
          find.byType(EditableText),
        );

        expect(editableText.obscureText, isTrue);
      },
    );

    testWidgets(
      'Debe mostrar icono prefijo y sufijo',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CustomTextField(
                prefixIcon: Icons.email,
                suffixIcon: Icons.visibility,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.email), findsOneWidget);
        expect(find.byIcon(Icons.visibility), findsOneWidget);
      },
    );

    testWidgets(
      'Debe ejecutar acción al presionar el icono sufijo',
      (WidgetTester tester) async {
        bool fuePresionado = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomTextField(
                suffixIcon: Icons.visibility,
                onSuffixIconPressed: () {
                  fuePresionado = true;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.visibility));
        await tester.pump();

        expect(fuePresionado, isTrue);
      },
    );

    testWidgets(
      'Debe ejecutar correctamente el validator',
      (WidgetTester tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: CustomTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo requerido';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        );

        formKey.currentState!.validate();
        await tester.pump();

        expect(find.text('Campo requerido'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe estar deshabilitado cuando enabled es false',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CustomTextField(
                enabled: false,
              ),
            ),
          ),
        );

        final TextFormField field = tester.widget<TextFormField>(
          find.byType(TextFormField),
        );

        expect(field.enabled, isFalse);
      },
    );
  });
}