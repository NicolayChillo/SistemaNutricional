import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../lib/presentation/atoms/primary_button.dart';
import '../../../../lib/presentation/molecules/divider_with_text.dart';
import '../../../../lib/presentation/molecules/email_form_field.dart';
import '../../../../lib/presentation/molecules/password_form_field.dart';
import '../../../../lib/presentation/molecules/social_buttons_group.dart';
import '../../../../lib/presentation/organisms/forms/login_form.dart';

void main() {
  late GlobalKey<FormState> formKey;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  setUp(() {
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  });

  tearDown(() {
    emailController.dispose();
    passwordController.dispose();
  });

  Widget createWidget({
    VoidCallback? onLogin,
    VoidCallback? onGoogleLogin,
    VoidCallback? onFacebookLogin,
    bool isLoading = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: LoginForm(
          formKey: formKey,
          emailController: emailController,
          passwordController: passwordController,
          onLogin: onLogin,
          onGoogleLogin: onGoogleLogin,
          onFacebookLogin: onFacebookLogin,
          isLoading: isLoading,
        ),
      ),
    );
  }

  group('LoginForm Widget Tests', () {
    testWidgets('Debe mostrar email y contraseña', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(LoginForm), findsOneWidget);
      expect(find.byType(EmailFormField), findsOneWidget);
      expect(find.byType(PasswordFormField), findsOneWidget);
    });

    testWidgets('Debe mostrar botón de iniciar sesión', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text('Iniciar Sesión'), findsOneWidget);
    });

    testWidgets('Debe mostrar divisor y botones sociales', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byType(DividerWithText), findsOneWidget);
      expect(find.text('O inicia sesión con'), findsOneWidget);
      expect(find.byType(SocialButtonsGroup), findsOneWidget);
    });

    testWidgets('Debe ejecutar onLogin al presionar el botón', (tester) async {
      bool loginPressed = false;

      await tester.pumpWidget(
        createWidget(
          onLogin: () {
            loginPressed = true;
          },
        ),
      );

      await tester.tap(find.text('Iniciar Sesión'));
      await tester.pump();

      expect(loginPressed, isTrue);
    });

    testWidgets('Debe ejecutar callbacks sociales', (tester) async {
      bool googlePressed = false;
      bool facebookPressed = false;

      await tester.pumpWidget(
        createWidget(
          onGoogleLogin: () {
            googlePressed = true;
          },
          onFacebookLogin: () {
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

      await tester.enterText(fields.at(0), 'usuario@correo.com');
      await tester.enterText(fields.at(1), '123456');

      expect(emailController.text, 'usuario@correo.com');
      expect(passwordController.text, '123456');
    });
  });
}