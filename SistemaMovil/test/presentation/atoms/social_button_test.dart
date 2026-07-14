import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/presentation/atoms/social_button.dart';
import '../../../lib/presentation/theme/app_colors.dart';

void main() {
  group('SocialButton Widget Tests', () {
    testWidgets(
      'Debe mostrar correctamente el texto y el icono',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SocialButton(
                text: 'Continuar con Google',
                icon: Icons.login,
              ),
            ),
          ),
        );

        expect(find.byType(SocialButton), findsOneWidget);
        expect(find.text('Continuar con Google'), findsOneWidget);
        expect(find.byIcon(Icons.login), findsOneWidget);
      },
    );

    testWidgets(
      'Debe ejecutar onPressed cuando se presiona',
      (WidgetTester tester) async {
        bool fuePresionado = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SocialButton(
                text: 'Iniciar sesión',
                icon: Icons.login,
                onPressed: () {
                  fuePresionado = true;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(SocialButton));
        await tester.pump();

        expect(fuePresionado, isTrue);
      },
    );

    testWidgets(
      'Debe aplicar colores personalizados',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SocialButton(
                text: 'Facebook',
                icon: Icons.facebook,
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        );

        final Icon iconWidget = tester.widget<Icon>(
          find.byIcon(Icons.facebook),
        );

        final Text textWidget = tester.widget<Text>(
          find.text('Facebook'),
        );

        expect(iconWidget.color, isNull);
        expect(textWidget.data, 'Facebook');

        final SocialButton socialButton = tester.widget<SocialButton>(
          find.byType(SocialButton),
        );

        expect(socialButton.foregroundColor, Colors.blue);
        expect(socialButton.backgroundColor, Colors.white);
      },
    );

    testWidgets(
      'Debe utilizar hunterGreen cuando no se proporciona color personalizado',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SocialButton(
                text: 'Ingresar',
                icon: Icons.person,
              ),
            ),
          ),
        );

        final SocialButton socialButton = tester.widget<SocialButton>(
          find.byType(SocialButton),
        );

        expect(socialButton.foregroundColor, isNull);
        expect(socialButton.backgroundColor, isNull);

        final BuildContext context = tester.element(
          find.byType(SocialButton),
        );

        final Widget builtWidget = socialButton.build(context);

        expect(builtWidget, isA<OutlinedButton>());

        final OutlinedButton button = builtWidget as OutlinedButton;

        final Color? foregroundColor =
            button.style?.foregroundColor?.resolve({});

        final BorderSide? borderSide =
            button.style?.side?.resolve({});

        expect(foregroundColor, AppColors.hunterGreen);
        expect(borderSide?.color, AppColors.hunterGreen);
      },
    );
  });
}