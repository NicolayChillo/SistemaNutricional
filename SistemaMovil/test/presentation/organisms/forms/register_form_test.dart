import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/presentation/atoms/primary_button.dart';
import '../../../../lib/presentation/molecules/divider_with_text.dart';
import '../../../../lib/presentation/molecules/email_form_field.dart';
import '../../../../lib/presentation/molecules/name_form_field.dart';
import '../../../../lib/presentation/molecules/password_form_field.dart';
import '../../../../lib/presentation/molecules/social_buttons_group.dart';
import '../../../../lib/presentation/organisms/forms/register_form.dart';

void main() {
  late GlobalKey<FormState> formKey;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  setUp(() {
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  });

  tearDown(() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  });

  Widget createWidget({
    VoidCallback? onRegister,
    VoidCallback? onGoogleRegister,
    VoidCallback? onFacebookRegister,
    bool isLoading = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: RegisterForm(
          formKey: formKey,
          nameController: nameController,
          emailController: emailController,
          passwordController: passwordController,
          onRegister: onRegister,
          onGoogleRegister: onGoogleRegister,
          onFacebookRegister: onFacebookRegister,
          isLoading: isLoading,
        ),
      ),
    );
  }

  group('RegisterForm Widget Tests', () {
    testWidgets('Debe mostrar los tres campos', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(RegisterForm), findsOneWidget);
      expect(find.byType(NameFormField), findsOneWidget);
      expect(find.byType(EmailFormField), findsOneWidget);
      expect(find.byType(PasswordFormField), findsOneWidget);
    });

    testWidgets('Debe mostrar botón Registrarse', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text('Registrarse'), findsOneWidget);
    });

    testWidgets('Debe mostrar divisor y botones sociales', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(DividerWithText), findsOneWidget);
      expect(find.text('O regístrate con'), findsOneWidget);
      expect(find.byType(SocialButtonsGroup), findsOneWidget);
    });

    testWidgets('Debe ejecutar onRegister', (tester) async {
      bool registerPressed = false;

      await tester.pumpWidget(
        createWidget(
          onRegister: () {
            registerPressed = true;
          },
        ),
      );

      await tester.tap(find.text('Registrarse'));
      await tester.pump();

      expect(registerPressed, isTrue);
    });

    testWidgets('Debe ejecutar callbacks sociales', (tester) async {
      bool googlePressed = false;
      bool facebookPressed = false;

      await tester.pumpWidget(
        createWidget(
          onGoogleRegister: () {
            googlePressed = true;
          },
          onFacebookRegister: () {
            facebookPressed = true;
          },
        ),
      );

      await tester.tap(find.text('Google'));
      await tester.pump();

      await tester.tap(find.text('Facebook'));
      await tester.pump();

      expect(googlePressed, isTrue);
      expect(facebookPressed, isTrue);
    });

    testWidgets(
      'Debe mostrar indicador de carga cuando isLoading es true',
      (tester) async {
        await tester.pumpWidget(
          createWidget(isLoading: true),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(PrimaryButton), findsNothing);
        expect(find.byType(SocialButtonsGroup), findsNothing);
      },
    );

    testWidgets('Debe usar los controllers proporcionados', (tester) async {
      await tester.pumpWidget(createWidget());

      final fields = find.byType(TextFormField);

      await tester.enterText(fields.at(0), 'Sebastián');
      await tester.enterText(fields.at(1), 'sebas@correo.com');
      await tester.enterText(fields.at(2), '123456');

      expect(nameController.text, 'Sebastián');
      expect(emailController.text, 'sebas@correo.com');
      expect(passwordController.text, '123456');
    });
  });
}