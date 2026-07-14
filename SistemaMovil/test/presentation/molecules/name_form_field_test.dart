import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/atoms/custom_text_field.dart';
import '../../../lib/presentation/molecules/name_form_field.dart';

void main() {
  group('NameFormField Widget Tests', () {
    testWidgets(
      'Debe mostrar label, hint e icono correctamente',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NameFormField(),
            ),
          ),
        );

        expect(find.byType(NameFormField), findsOneWidget);
        expect(find.byType(CustomTextField), findsOneWidget);
        expect(find.text('Nombre'), findsOneWidget);
        expect(find.text('Ingrese su nombre'), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
      },
    );

    testWidgets(
      'Debe utilizar un label personalizado',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NameFormField(
                label: 'Nombre completo',
              ),
            ),
          ),
        );

        expect(find.text('Nombre completo'), findsOneWidget);
        expect(find.text('Nombre'), findsNothing);
      },
    );

    testWidgets(
      'Debe mostrar error cuando el nombre está vacío',
      (WidgetTester tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: const NameFormField(),
              ),
            ),
          ),
        );

        formKey.currentState!.validate();
        await tester.pump();

        expect(
          find.text('Por favor ingrese su nombre'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe mostrar error cuando el nombre tiene menos de 2 caracteres',
      (WidgetTester tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: const NameFormField(),
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byType(TextFormField),
          'A',
        );

        formKey.currentState!.validate();
        await tester.pump();

        expect(
          find.text('El nombre debe tener al menos 2 caracteres'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe aceptar un nombre válido',
      (WidgetTester tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: const NameFormField(),
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byType(TextFormField),
          'Sebastián',
        );

        final bool isValid = formKey.currentState!.validate();
        await tester.pump();

        expect(isValid, isTrue);
        expect(
          find.text('Por favor ingrese su nombre'),
          findsNothing,
        );
        expect(
          find.text('El nombre debe tener al menos 2 caracteres'),
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
              body: NameFormField(
                controller: controller,
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byType(TextFormField),
          'Juan Pérez',
        );

        expect(controller.text, 'Juan Pérez');

        controller.dispose();
      },
    );
  });
}