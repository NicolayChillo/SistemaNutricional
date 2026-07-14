import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/presentation/organisms/recipe/recipe_basic_info_section.dart';

void main() {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController preparationTimeController;
  late TextEditingController servingsController;
  late TextEditingController categoryController;

  setUp(() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    preparationTimeController = TextEditingController();
    servingsController = TextEditingController();
    categoryController = TextEditingController();
  });

  tearDown(() {
    titleController.dispose();
    descriptionController.dispose();
    preparationTimeController.dispose();
    servingsController.dispose();
    categoryController.dispose();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          child: RecipeBasicInfoSection(
            titleController: titleController,
            descriptionController: descriptionController,
            preparationTimeController: preparationTimeController,
            servingsController: servingsController,
            categoryController: categoryController,
          ),
        ),
      ),
    );
  }

  group('RecipeBasicInfoSection Widget Tests', () {
    testWidgets(
      'Debe mostrar los cinco campos del formulario',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.byType(RecipeBasicInfoSection), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(5));

        expect(find.text('Título'), findsOneWidget);
        expect(find.text('Descripción'), findsOneWidget);
        expect(find.text('Tiempo (min)'), findsOneWidget);
        expect(find.text('Porciones'), findsOneWidget);
        expect(find.text('Categoría'), findsOneWidget);
      },
    );

    testWidgets(
      'Debe actualizar correctamente todos los controllers',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final fields = find.byType(TextFormField);

        await tester.enterText(fields.at(0), 'Arroz con pollo');
        await tester.enterText(fields.at(1), 'Una receta deliciosa');
        await tester.enterText(fields.at(2), '30');
        await tester.enterText(fields.at(3), '4');
        await tester.enterText(fields.at(4), 'Almuerzo');

        expect(titleController.text, 'Arroz con pollo');
        expect(descriptionController.text, 'Una receta deliciosa');
        expect(preparationTimeController.text, '30');
        expect(servingsController.text, '4');
        expect(categoryController.text, 'Almuerzo');
      },
    );

    testWidgets(
      'Debe mostrar error cuando el título está vacío',
      (WidgetTester tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: RecipeBasicInfoSection(
                  titleController: titleController,
                  descriptionController: descriptionController,
                  preparationTimeController: preparationTimeController,
                  servingsController: servingsController,
                  categoryController: categoryController,
                ),
              ),
            ),
          ),
        );

        descriptionController.text = 'Descripción válida';

        formKey.currentState!.validate();
        await tester.pump();

        expect(
          find.text('Por favor ingrese un título'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe mostrar error cuando la descripción está vacía',
      (WidgetTester tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: RecipeBasicInfoSection(
                  titleController: titleController,
                  descriptionController: descriptionController,
                  preparationTimeController: preparationTimeController,
                  servingsController: servingsController,
                  categoryController: categoryController,
                ),
              ),
            ),
          ),
        );

        titleController.text = 'Título válido';

        formKey.currentState!.validate();
        await tester.pump();

        expect(
          find.text('Por favor ingrese una descripción'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Debe aceptar formulario con título y descripción válidos',
      (WidgetTester tester) async {
        final formKey = GlobalKey<FormState>();

        titleController.text = 'Pizza casera';
        descriptionController.text = 'Receta sencilla de pizza';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Form(
                key: formKey,
                child: RecipeBasicInfoSection(
                  titleController: titleController,
                  descriptionController: descriptionController,
                  preparationTimeController: preparationTimeController,
                  servingsController: servingsController,
                  categoryController: categoryController,
                ),
              ),
            ),
          ),
        );

        final isValid = formKey.currentState!.validate();
        await tester.pump();

        expect(isValid, isTrue);
        expect(
          find.text('Por favor ingrese un título'),
          findsNothing,
        );
        expect(
          find.text('Por favor ingrese una descripción'),
          findsNothing,
        );
      },
    );

    testWidgets(
        'Descripción debe permitir máximo tres líneas',
        (WidgetTester tester) async {
            await tester.pumpWidget(createTestWidget());

            final EditableText descriptionField =
                tester.widget<EditableText>(
            find.byType(EditableText).at(1),
            );

            expect(descriptionField.maxLines, 3);
        },
    );

    testWidgets(
      'Tiempo y porciones deben utilizar teclado numérico',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());

        final EditableText preparationField =
            tester.widget<EditableText>(
          find.byType(EditableText).at(2),
        );

        final EditableText servingsField =
            tester.widget<EditableText>(
          find.byType(EditableText).at(3),
        );

        expect(
          preparationField.keyboardType,
          TextInputType.number,
        );

        expect(
          servingsField.keyboardType,
          TextInputType.number,
        );
      },
    );
  });
}