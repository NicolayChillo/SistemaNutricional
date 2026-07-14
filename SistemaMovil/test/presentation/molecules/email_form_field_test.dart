import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/atoms/custom_text_field.dart';
import '../../../lib/presentation/molecules/email_form_field.dart';

void main() {
  group('EmailFormField Widget Tests', () {
    testWidgets(
      'Debe mostrar label, hint e icono correctamente',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: EmailFormField(),
            ),
          ),
        );

        expect(find.byType(EmailFormField), findsOneWidget);
        expect(find.byType(CustomTextField), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('ejemplo@correo.com'), findsOneWidget);
        expect(find.byIcon(Icons.email), findsOneWidget);
      },
    );

    testWidgets(
      'Debe utilizar un label personalizado',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: EmailFormField(
                label: 'Correo electrónico',
              ),
            ),
          ),
        );

        expect(find.text('Correo electrónico'), findsOneWidget);
        expect(find.text('Email'), findsNothing);
      },
    );

    testWidgets(
      'Debe mostrar error cuando el email está vacío',
      (WidgetTester tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: const EmailFormField(),
              ),
            ),
          ),
        );

        formKey.currentState!.validate();
        await tester.pump();

        expect(
          find.text('Por favor ingrese su email'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe mostrar error cuando el email no contiene arroba',
      (WidgetTester tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: const EmailFormField(),
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byType(TextFormField),
          'correo-invalido',
        );

        formKey.currentState!.validate();
        await tester.pump();

        expect(
          find.text('Por favor ingrese un email válido'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe aceptar un email válido',
      (WidgetTester tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: const EmailFormField(),
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byType(TextFormField),
          'usuario@correo.com',
        );

        final bool isValid = formKey.currentState!.validate();
        await tester.pump();

        expect(isValid, isTrue);
        expect(
          find.text('Por favor ingrese su email'),
          findsNothing,
        );
        expect(
          find.text('Por favor ingrese un email válido'),
          findsNothing,
        );
      },
    );

    testWidgets(
      'Debe actualizar correctamente el controller',
      (WidgetTester tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EmailFormField(
                controller: controller,
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byType(TextFormField),
          'test@example.com',
        );

        expect(controller.text, 'test@example.com');

        controller.dispose();
      },
    );
  });
}