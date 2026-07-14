import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/atoms/custom_text_field.dart';
import '../../../lib/presentation/molecules/password_form_field.dart';

void main() {
  group('PasswordFormField Widget Tests', () {
    testWidgets(
      'Debe mostrar label e iconos correctamente',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: PasswordFormField(),
            ),
          ),
        );

        expect(find.byType(PasswordFormField), findsOneWidget);
        expect(find.byType(CustomTextField), findsOneWidget);
        expect(find.text('Contraseña'), findsOneWidget);
        expect(find.byIcon(Icons.lock), findsOneWidget);
        expect(find.byIcon(Icons.visibility), findsOneWidget);
      },
    );

    testWidgets(
      'Debe utilizar label personalizado',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: PasswordFormField(
                label: 'Clave de acceso',
              ),
            ),
          ),
        );

        expect(find.text('Clave de acceso'), findsOneWidget);
        expect(find.text('Contraseña'), findsNothing);
      },
    );

    testWidgets(
      'Debe ocultar la contraseña inicialmente',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: PasswordFormField(),
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
      'Debe mostrar la contraseña al presionar el icono de visibilidad',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: PasswordFormField(),
            ),
          ),
        );

        expect(find.byIcon(Icons.visibility), findsOneWidget);

        await tester.tap(find.byIcon(Icons.visibility));
        await tester.pump();

        final EditableText editableText = tester.widget<EditableText>(
          find.byType(EditableText),
        );

        expect(editableText.obscureText, isFalse);
        expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      },
    );

    testWidgets(
      'Debe volver a ocultar la contraseña al presionar dos veces',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: PasswordFormField(),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.visibility));
        await tester.pump();

        await tester.tap(find.byIcon(Icons.visibility_off));
        await tester.pump();

        final EditableText editableText = tester.widget<EditableText>(
          find.byType(EditableText),
        );

        expect(editableText.obscureText, isTrue);
        expect(find.byIcon(Icons.visibility), findsOneWidget);
      },
    );

    testWidgets(
      'Debe mostrar error cuando la contraseña está vacía',
      (WidgetTester tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: const PasswordFormField(),
              ),
            ),
          ),
        );

        formKey.currentState!.validate();
        await tester.pump();

        expect(
          find.text('Por favor ingrese su contraseña'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe mostrar error cuando no cumple la longitud mínima',
      (WidgetTester tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: const PasswordFormField(
                  minLength: 6,
                ),
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byType(TextFormField),
          '123',
        );

        formKey.currentState!.validate();
        await tester.pump();

        expect(
          find.text('La contraseña debe tener al menos 6 caracteres'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe respetar longitud mínima personalizada',
      (WidgetTester tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: const PasswordFormField(
                  minLength: 10,
                ),
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byType(TextFormField),
          '123456',
        );

        formKey.currentState!.validate();
        await tester.pump();

        expect(
          find.text('La contraseña debe tener al menos 10 caracteres'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe aceptar una contraseña válida',
      (WidgetTester tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: const PasswordFormField(),
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byType(TextFormField),
          'password123',
        );

        final bool isValid = formKey.currentState!.validate();
        await tester.pump();

        expect(isValid, isTrue);
      },
    );
  });
}